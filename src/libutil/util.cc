#include "util.hh"
#include "affinity.hh"
#include "sync.hh"
#include "finally.hh"

#include <cctype>
#include <cerrno>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <sstream>
#include <thread>
#include <future>

#include <sys/wait.h>
#include <unistd.h>
#include <fcntl.h>
#include <limits.h>

#ifdef __APPLE__
#include <sys/syscall.h>
#endif

#ifdef __linux__
#include <sys/prctl.h>
#endif


extern char * * environ;


namespace nix {


BaseError & BaseError::addPrefix(const FormatOrString & fs)
{
    prefix_ = fs.s + prefix_;
    return *this;
}


std::string SysError::addErrno(const std::string & s)
{
    errNo = errno;
    return s + ": " + strerror(errNo);
}


string getEnv(const string & key, const string & def)
{
    char * value = getenv(key.c_str());
    return value ? string(value) : def;
}


std::map<std::string, std::string> getEnv()
{
    std::map<std::string, std::string> env;
    for (size_t i = 0; environ[i]; ++i) {
        auto s = environ[i];
        auto eq = strchr(s, '=');
        if (!eq)
            // invalid env, just keep going
            continue;
        env.emplace(std::string(s, eq), std::string(eq + 1));
    }
    return env;
}


Path absPath(Path path, Path dir)
{
    if (path[0] != '/') {
        if (dir == "") {
#ifdef __GNU__
            /* GNU (aka. GNU/Hurd) doesn't have any limitation on path
               lengths and doesn't define `PATH_MAX'.  */
            char *buf = getcwd(NULL, 0);
            if (buf == NULL)
#else
            char buf[PATH_MAX];
            if (!getcwd(buf, sizeof(buf)))
#endif
                throw SysError("cannot get cwd");
            dir = buf;
#ifdef __GNU__
            free(buf);
#endif
        }
        path = dir + "/" + path;
    }
    return canonPath(path);
}


Path canonPath(const Path & path, bool resolveSymlinks)
{
    assert(path != "");

    string s;

    if (path[0] != '/')
        throw Error(format("not an absolute path: ‘%1%’") % path);

    string::const_iterator i = path.begin(), end = path.end();
    string temp;

    /* Count the number of times we follow a symlink and stop at some
       arbitrary (but high) limit to prevent infinite loops. */
    unsigned int followCount = 0, maxFollow = 1024;

    while (1) {

        /* Skip slashes. */
        while (i != end && *i == '/') i++;
        if (i == end) break;

        /* Ignore `.'. */
        if (*i == '.' && (i + 1 == end || i[1] == '/'))
            i++;

        /* If `..', delete the last component. */
        else if (*i == '.' && i + 1 < end && i[1] == '.' &&
            (i + 2 == end || i[2] == '/'))
        {
            if (!s.empty()) s.erase(s.rfind('/'));
            i += 2;
        }

        /* Normal component; copy it. */
        else {
            s += '/';
            while (i != end && *i != '/') s += *i++;

            /* If s points to a symlink, resolve it and restart (since
               the symlink target might contain new symlinks). */
            if (resolveSymlinks && isLink(s)) {
                if (++followCount >= maxFollow)
                    throw Error(format("infinite symlink recursion in path ‘%1%’") % path);
                temp = absPath(readLink(s), dirOf(s))
                    + string(i, end);
                i = temp.begin(); /* restart */
                end = temp.end();
                s = "";
            }
        }
    }

    return s.empty() ? "/" : s;
}


Path dirOf(const Path & path)
{
    Path::size_type pos = path.rfind('/');
    if (pos == string::npos)
        throw Error(format("invalid file name ‘%1%’") % path);
    return pos == 0 ? "/" : Path(path, 0, pos);
}


string baseNameOf(const Path & path)
{
    if (path.empty())
        return "";

    Path::size_type last = path.length() - 1;
    if (path[last] == '/' && last > 0)
        last -= 1;

    Path::size_type pos = path.rfind('/', last);
    if (pos == string::npos)
        pos = 0;
    else
        pos += 1;

    return string(path, pos, last - pos + 1);
}


bool isInDir(const Path & path, const Path & dir)
{
    return path[0] == '/'
        && string(path, 0, dir.size()) == dir
        && path.size() >= dir.size() + 2
        && path[dir.size()] == '/';
}


struct stat lstat(const Path & path)
{
    struct stat st;
    if (lstat(path.c_str(), &st))
        throw SysError(format("getting status of ‘%1%’") % path);
    return st;
}


bool pathExists(const Path & path)
{
    int res;
    struct stat st;
    res = lstat(path.c_str(), &st);
    if (!res) return true;
    if (errno != ENOENT && errno != ENOTDIR)
        throw SysError(format("getting status of %1%") % path);
    return false;
}


Path readLink(const Path & path)
{
    checkInterrupt();
    struct stat st = lstat(path);
    if (!S_ISLNK(st.st_mode))
        throw Error(format("‘%1%’ is not a symlink") % path);
    char buf[st.st_size];
    ssize_t rlsize = readlink(path.c_str(), buf, st.st_size);
    if (rlsize == -1)
        throw SysError(format("reading symbolic link ‘%1%’") % path);
    else if (rlsize > st.st_size)
        throw Error(format("symbolic link ‘%1%’ size overflow %2% > %3%")
            % path % rlsize % st.st_size);
    return string(buf, rlsize);
}


bool isLink(const Path & path)
{
    struct stat st = lstat(path);
    return S_ISLNK(st.st_mode);
}


DirEntries readDirectory(const Path & path)
{
    DirEntries entries;
    entries.reserve(64);

    AutoCloseDir dir(opendir(path.c_str()));
    if (!dir) throw SysError(format("opening directory ‘%1%’") % path);

    struct dirent * dirent;
    while (errno = 0, dirent = readdir(dir.get())) { /* sic */
        checkInterrupt();
        string name = dirent->d_name;
        if (name == "." || name == "..") continue;
        entries.emplace_back(name, dirent->d_ino,
#ifdef HAVE_STRUCT_DIRENT_D_TYPE
            dirent->d_type
#else
            DT_UNKNOWN
#endif
        );
    }
    if (errno) throw SysError(format("reading directory ‘%1%’") % path);

    return entries;
}


unsigned char getFileType(const Path & path)
{
    struct stat st = lstat(path);
    if (S_ISDIR(st.st_mode)) return DT_DIR;
    if (S_ISLNK(st.st_mode)) return DT_LNK;
    if (S_ISREG(st.st_mode)) return DT_REG;
    return DT_UNKNOWN;
}


string readFile(int fd)
{
    struct stat st;
    if (fstat(fd, &st) == -1)
        throw SysError("statting file");

    auto buf = std::make_unique<unsigned char[]>(st.st_size);
    readFull(fd, buf.get(), st.st_size);

    return string((char *) buf.get(), st.st_size);
}


string readFile(const Path & path, bool drain)
{
    AutoCloseFD fd = open(path.c_str(), O_RDONLY | O_CLOEXEC);
    if (!fd)
        throw SysError(format("opening file ‘%1%’") % path);
    return drain ? drainFD(fd.get()) : readFile(fd.get());
}


void writeFile(const Path & path, const string & s, mode_t mode)
{
    AutoCloseFD fd = open(path.c_str(), O_WRONLY | O_TRUNC | O_CREAT | O_CLOEXEC, mode);
    if (!fd)
        throw SysError(format("opening file ‘%1%’") % path);
    writeFull(fd.get(), s);
}


string readLine(int fd)
{
    string s;
    while (1) {
        checkInterrupt();
        char ch;
        ssize_t rd = read(fd, &ch, 1);
        if (rd == -1) {
            if (errno != EINTR)
                throw SysError("reading a line");
        } else if (rd == 0)
            throw EndOfFile("unexpected EOF reading a line");
        else {
            if (ch == '\n') return s;
            s += ch;
        }
    }
}


void writeLine(int fd, string s)
{
    s += '\n';
    writeFull(fd, s);
}


static void _deletePath(const Path & path, unsigned long long & bytesFreed)
{
    checkInterrupt();

    struct stat st;
    if (lstat(path.c_str(), &st) == -1) {
        if (errno == ENOENT) return;
        throw SysError(format("getting status of ‘%1%’") % path);
    }

    if (!S_ISDIR(st.st_mode) && st.st_nlink == 1)
        bytesFreed += st.st_blocks * 512;

    if (S_ISDIR(st.st_mode)) {
        /* Make the directory accessible. */
        const auto PERM_MASK = S_IRUSR | S_IWUSR | S_IXUSR;
        if ((st.st_mode & PERM_MASK) != PERM_MASK) {
            if (chmod(path.c_str(), st.st_mode | PERM_MASK) == -1)
                throw SysError(format("chmod ‘%1%’") % path);
        }

        for (auto & i : readDirectory(path))
            _deletePath(path + "/" + i.name, bytesFreed);
    }

    if (remove(path.c_str()) == -1) {
        if (errno == ENOENT) return;
        throw SysError(format("cannot unlink ‘%1%’") % path);
    }
}


void deletePath(const Path & path)
{
    unsigned long long dummy;
    deletePath(path, dummy);
}


void deletePath(const Path & path, unsigned long long & bytesFreed)
{
    Activity act(*logger, lvlDebug, format("recursively deleting path ‘%1%’") % path);
    bytesFreed = 0;
    _deletePath(path, bytesFreed);
}


static Path tempName(Path tmpRoot, const Path & prefix, bool includePid,
    int & counter)
{
    tmpRoot = canonPath(tmpRoot.empty() ? getEnv("TMPDIR", "/tmp") : tmpRoot, true);
    if (includePid)
        return (format("%1%/%2%-%3%-%4%") % tmpRoot % prefix % getpid() % counter++).str();
    else
        return (format("%1%/%2%-%3%") % tmpRoot % prefix % counter++).str();
}


Path createTempDir(const Path & tmpRoot, const Path & prefix,
    bool includePid, bool useGlobalCounter, mode_t mode)
{
    static int globalCounter = 0;
    int localCounter = 0;
    int & counter(useGlobalCounter ? globalCounter : localCounter);

    while (1) {
        checkInterrupt();
        Path tmpDir = tempName(tmpRoot, prefix, includePid, counter);
        if (mkdir(tmpDir.c_str(), mode) == 0) {
#if __FreeBSD__
            /* Explicitly set the group of the directory.  This is to
               work around around problems caused by BSD's group
               ownership semantics (directories inherit the group of
               the parent).  For instance, the group of /tmp on
               FreeBSD is "wheel", so all directories created in /tmp
               will be owned by "wheel"; but if the user is not in
               "wheel", then "tar" will fail to unpack archives that
               have the setgid bit set on directories. */
            if (chown(tmpDir.c_str(), (uid_t) -1, getegid()) != 0)
                throw SysError(format("setting group of directory ‘%1%’") % tmpDir);
#endif
            return tmpDir;
        }
        if (errno != EEXIST)
            throw SysError(format("creating directory ‘%1%’") % tmpDir);
    }
}


Path getCacheDir()
{
    Path cacheDir = getEnv("XDG_CACHE_HOME");
    if (cacheDir.empty()) {
        Path homeDir = getEnv("HOME");
        if (homeDir.empty()) throw Error("$XDG_CACHE_HOME and $HOME are not set");
        cacheDir = homeDir + "/.cache";
    }
    return cacheDir;
}


Path getConfigDir()
{
    Path configDir = getEnv("XDG_CONFIG_HOME");
    if (configDir.empty()) {
        Path homeDir = getEnv("HOME");
        if (homeDir.empty()) throw Error("$XDG_CONFIG_HOME and $HOME are not set");
        configDir = homeDir + "/.config";
    }
    return configDir;
}


Path getDataDir()
{
    Path dataDir = getEnv("XDG_DATA_HOME");
    if (dataDir.empty()) {
        Path homeDir = getEnv("HOME");
        if (homeDir.empty()) throw Error("$XDG_DATA_HOME and $HOME are not set");
        dataDir = homeDir + "/.local/share";
    }
    return dataDir;
}


Paths createDirs(const Path & path)
{
    Paths created;
    if (path == "/") return created;

    struct stat st;
    if (lstat(path.c_str(), &st) == -1) {
        created = createDirs(dirOf(path));
        if (mkdir(path.c_str(), 0777) == -1 && errno != EEXIST)
            throw SysError(format("creating directory ‘%1%’") % path);
        st = lstat(path);
        created.push_back(path);
    }

    if (S_ISLNK(st.st_mode) && stat(path.c_str(), &st) == -1)
        throw SysError(format("statting symlink ‘%1%’") % path);

    if (!S_ISDIR(st.st_mode)) throw Error(format("‘%1%’ is not a directory") % path);

    return created;
}


void createSymlink(const Path & target, const Path & link)
{
    if (symlink(target.c_str(), link.c_str()))
        throw SysError(format("creating symlink from ‘%1%’ to ‘%2%’") % link % target);
}


void replaceSymlink(const Path & target, const Path & link)
{
    Path tmp = canonPath(dirOf(link) + "/.new_" + baseNameOf(link));

    createSymlink(target, tmp);

    if (rename(tmp.c_str(), link.c_str()) != 0)
        throw SysError(format("renaming ‘%1%’ to ‘%2%’") % tmp % link);
}


void readFull(int fd, unsigned char * buf, size_t count)
{
    while (count) {
        checkInterrupt();
        ssize_t res = read(fd, (char *) buf, count);
        if (res == -1) {
            if (errno == EINTR) continue;
            throw SysError("reading from file");
        }
        if (res == 0) throw EndOfFile("unexpected end-of-file");
        count -= res;
        buf += res;
    }
}


void writeFull(int fd, const unsigned char * buf, size_t count, bool allowInterrupts)
{
    while (count) {
        if (allowInterrupts) checkInterrupt();
        ssize_t res = write(fd, (char *) buf, count);
        if (res == -1 && errno != EINTR)
            throw SysError("writing to file");
        if (res > 0) {
            count -= res;
            buf += res;
        }
    }
}


void writeFull(int fd, const string & s, bool allowInterrupts)
{
    writeFull(fd, (const unsigned char *) s.data(), s.size(), allowInterrupts);
}


string drainFD(int fd)
{
    string result;
    unsigned char buffer[4096];
    while (1) {
        checkInterrupt();
        ssize_t rd = read(fd, buffer, sizeof buffer);
        if (rd == -1) {
            if (errno != EINTR)
                throw SysError("reading from file");
        }
        else if (rd == 0) break;
        else result.append((char *) buffer, rd);
    }
    return result;
}



//////////////////////////////////////////////////////////////////////


AutoDelete::AutoDelete() : del{false} {}

AutoDelete::AutoDelete(const string & p, bool recursive) : path(p)
{
    del = true;
    this->recursive = recursive;
}

AutoDelete::~AutoDelete()
{
    try {
        if (del) {
            if (recursive)
                deletePath(path);
            else {
                if (remove(path.c_str()) == -1)
                    throw SysError(format("cannot unlink ‘%1%’") % path);
            }
        }
    } catch (...) {
        ignoreException();
    }
}

void AutoDelete::cancel()
{
    del = false;
}

void AutoDelete::reset(const Path & p, bool recursive) {
    path = p;
    this->recursive = recursive;
    del = true;
}



//////////////////////////////////////////////////////////////////////


AutoCloseFD::AutoCloseFD() : fd{-1} {}


AutoCloseFD::AutoCloseFD(int fd) : fd{fd} {}


AutoCloseFD::AutoCloseFD(AutoCloseFD&& that) : fd{that.fd}
{
    that.fd = -1;
}


AutoCloseFD& AutoCloseFD::operator =(AutoCloseFD&& that)
{
    close();
    fd = that.fd;
    that.fd = -1;
    return *this;
}


AutoCloseFD::~AutoCloseFD()
{
    try {
        close();
    } catch (...) {
        ignoreException();
    }
}


int AutoCloseFD::get() const
{
    return fd;
}


void AutoCloseFD::close()
{
    if (fd != -1) {
        if (::close(fd) == -1)
            /* This should never happen. */
            throw SysError(format("closing file descriptor %1%") % fd);
    }
}


AutoCloseFD::operator bool() const
{
    return fd != -1;
}


int AutoCloseFD::release()
{
    int oldFD = fd;
    fd = -1;
    return oldFD;
}


void Pipe::create()
{
    int fds[2];
#if HAVE_PIPE2
    if (pipe2(fds, O_CLOEXEC) != 0) throw SysError("creating pipe");
#else
    if (pipe(fds) != 0) throw SysError("creating pipe");
    closeOnExec(fds[0]);
    closeOnExec(fds[1]);
#endif
    readSide = fds[0];
    writeSide = fds[1];
}



//////////////////////////////////////////////////////////////////////


Pid::Pid()
{
}


Pid::Pid(pid_t pid)
    : pid(pid)
{
}


Pid::~Pid()
{
    if (pid != -1) kill();
}


void Pid::operator =(pid_t pid)
{
    if (this->pid != -1 && this->pid != pid) kill();
    this->pid = pid;
    killSignal = SIGKILL; // reset signal to default
}


Pid::operator pid_t()
{
    return pid;
}


int Pid::kill()
{
    assert(pid != -1);

    debug(format("killing process %1%") % pid);

    /* Send the requested signal to the child.  If it has its own
       process group, send the signal to every process in the child
       process group (which hopefully includes *all* its children). */
    if (::kill(separatePG ? -pid : pid, killSignal) != 0)
        printError((SysError(format("killing process %1%") % pid).msg()));

    return wait();
}


int Pid::wait()
{
    assert(pid != -1);
    while (1) {
        int status;
        int res = waitpid(pid, &status, 0);
        if (res == pid) {
            pid = -1;
            return status;
        }
        if (errno != EINTR)
            throw SysError("cannot get child exit status");
        checkInterrupt();
    }
}


void Pid::setSeparatePG(bool separatePG)
{
    this->separatePG = separatePG;
}


void Pid::setKillSignal(int signal)
{
    this->killSignal = signal;
}


pid_t Pid::release()
{
    pid_t p = pid;
    pid = -1;
    return p;
}


void killUser(uid_t uid)
{
    debug(format("killing all processes running under uid ‘%1%’") % uid);

    assert(uid != 0); /* just to be safe... */

    /* The system call kill(-1, sig) sends the signal `sig' to all
       users to which the current process can send signals.  So we
       fork a process, switch to uid, and send a mass kill. */

    ProcessOptions options;
    options.allowVfork = false;

    Pid pid = startProcess([&]() {

        if (setuid(uid) == -1)
            throw SysError("setting uid");

        while (true) {
#ifdef __APPLE__
            /* OSX's kill syscall takes a third parameter that, among
               other things, determines if kill(-1, signo) affects the
               calling process. In the OSX libc, it's set to true,
               which means "follow POSIX", which we don't want here
                 */
            if (syscall(SYS_kill, -1, SIGKILL, false) == 0) break;
#else
            if (kill(-1, SIGKILL) == 0) break;
#endif
            if (errno == ESRCH) break; /* no more processes */
            if (errno != EINTR)
                throw SysError(format("cannot kill processes for uid ‘%1%’") % uid);
        }

        _exit(0);
    }, options);

    int status = pid.wait();
    if (status != 0)
        throw Error(format("cannot kill processes for uid ‘%1%’: %2%") % uid % statusToString(status));

    /* !!! We should really do some check to make sure that there are
       no processes left running under `uid', but there is no portable
       way to do so (I think).  The most reliable way may be `ps -eo
       uid | grep -q $uid'. */
}


//////////////////////////////////////////////////////////////////////


/* Wrapper around vfork to prevent the child process from clobbering
   the caller's stack frame in the parent. */
static pid_t doFork(bool allowVfork, std::function<void()> fun) __attribute__((noinline));
static pid_t doFork(bool allowVfork, std::function<void()> fun)
{
#ifdef __linux__
    pid_t pid = allowVfork ? vfork() : fork();
#else
    pid_t pid = fork();
#endif
    if (pid != 0) return pid;
    fun();
    abort();
}


pid_t startProcess(std::function<void()> fun, const ProcessOptions & options)
{
    auto wrapper = [&]() {
        if (!options.allowVfork)
            logger = makeDefaultLogger();
        try {
#if __linux__
            if (options.dieWithParent && prctl(PR_SET_PDEATHSIG, SIGKILL) == -1)
                throw SysError("setting death signal");
#endif
            restoreAffinity();
            fun();
        } catch (std::exception & e) {
            try {
                std::cerr << options.errorPrefix << e.what() << "\n";
            } catch (...) { }
        } catch (...) { }
        if (options.runExitHandlers)
            exit(1);
        else
            _exit(1);
    };

    pid_t pid = doFork(options.allowVfork, wrapper);
    if (pid == -1) throw SysError("unable to fork");

    return pid;
}


std::vector<char *> stringsToCharPtrs(const Strings & ss)
{
    std::vector<char *> res;
    for (auto & s : ss) res.push_back((char *) s.c_str());
    res.push_back(0);
    return res;
}


string runProgram(Path program, bool searchPath, const Strings & args,
    const std::experimental::optional<std::string> & input)
{
    checkInterrupt();

    /* Create a pipe. */
    Pipe out, in;
    out.create();
    if (input) in.create();

    /* Fork. */
    Pid pid = startProcess([&]() {
        if (dup2(out.writeSide.get(), STDOUT_FILENO) == -1)
            throw SysError("dupping stdout");
        if (input && dup2(in.readSide.get(), STDIN_FILENO) == -1)
            throw SysError("dupping stdin");

        Strings args_(args);
        args_.push_front(program);

        restoreSignals();

        if (searchPath)
            execvp(program.c_str(), stringsToCharPtrs(args_).data());
        else
            execv(program.c_str(), stringsToCharPtrs(args_).data());

        throw SysError(format("executing ‘%1%’") % program);
    });

    out.writeSide = -1;

    std::thread writerThread;

    std::promise<void> promise;

    Finally doJoin([&]() {
        if (writerThread.joinable())
            writerThread.join();
    });


    if (input) {
        in.readSide = -1;
        writerThread = std::thread([&]() {
            try {
                writeFull(in.writeSide.get(), *input);
                promise.set_value();
            } catch (...) {
                promise.set_exception(std::current_exception());
            }
            in.writeSide = -1;
        });
    }

    string result = drainFD(out.readSide.get());

    /* Wait for the child to finish. */
    int status = pid.wait();
    if (!statusOk(status))
        throw ExecError(status, format("program ‘%1%’ %2%")
            % program % statusToString(status));

    /* Wait for the writer thread to finish. */
    if (input) promise.get_future().get();

    return result;
}


void closeMostFDs(const set<int> & exceptions)
{
    int maxFD = 0;
    maxFD = sysconf(_SC_OPEN_MAX);
    for (int fd = 0; fd < maxFD; ++fd)
        if (fd != STDIN_FILENO && fd != STDOUT_FILENO && fd != STDERR_FILENO
            && exceptions.find(fd) == exceptions.end())
            close(fd); /* ignore result */
}


void closeOnExec(int fd)
{
    int prev;
    if ((prev = fcntl(fd, F_GETFD, 0)) == -1 ||
        fcntl(fd, F_SETFD, prev | FD_CLOEXEC) == -1)
        throw SysError("setting close-on-exec flag");
}


//////////////////////////////////////////////////////////////////////


bool _isInterrupted = false;

static thread_local bool interruptThrown = false;

void setInterruptThrown()
{
    interruptThrown = true;
}

void _interrupted()
{
    /* Block user interrupts while an exception is being handled.
       Throwing an exception while another exception is being handled
       kills the program! */
    if (!interruptThrown && !std::uncaught_exception()) {
        interruptThrown = true;
        throw Interrupted("interrupted by the user");
    }
}



//////////////////////////////////////////////////////////////////////


template<class C> C tokenizeString(const string & s, const string & separators)
{
    C result;
    string::size_type pos = s.find_first_not_of(separators, 0);
    while (pos != string::npos) {
        string::size_type end = s.find_first_of(separators, pos + 1);
        if (end == string::npos) end = s.size();
        string token(s, pos, end - pos);
        result.insert(result.end(), token);
        pos = s.find_first_not_of(separators, end);
    }
    return result;
}

template Strings tokenizeString(const string & s, const string & separators);
template StringSet tokenizeString(const string & s, const string & separators);
template vector<string> tokenizeString(const string & s, const string & separators);


string concatStringsSep(const string & sep, const Strings & ss)
{
    string s;
    for (auto & i : ss) {
        if (s.size() != 0) s += sep;
        s += i;
    }
    return s;
}


string concatStringsSep(const string & sep, const StringSet & ss)
{
    string s;
    for (auto & i : ss) {
        if (s.size() != 0) s += sep;
        s += i;
    }
    return s;
}


string chomp(const string & s)
{
    size_t i = s.find_last_not_of(" \n\r\t");
    return i == string::npos ? "" : string(s, 0, i + 1);
}


string trim(const string & s, const string & whitespace)
{
    auto i = s.find_first_not_of(whitespace);
    if (i == string::npos) return "";
    auto j = s.find_last_not_of(whitespace);
    return string(s, i, j == string::npos ? j : j - i + 1);
}


string replaceStrings(const std::string & s,
    const std::string & from, const std::string & to)
{
    if (from.empty()) return s;
    string res = s;
    size_t pos = 0;
    while ((pos = res.find(from, pos)) != std::string::npos) {
        res.replace(pos, from.size(), to);
        pos += to.size();
    }
    return res;
}


string statusToString(int status)
{
    if (!WIFEXITED(status) || WEXITSTATUS(status) != 0) {
        if (WIFEXITED(status))
            return (format("failed with exit code %1%") % WEXITSTATUS(status)).str();
        else if (WIFSIGNALED(status)) {
            int sig = WTERMSIG(status);
#if HAVE_STRSIGNAL
            const char * description = strsignal(sig);
            return (format("failed due to signal %1% (%2%)") % sig % description).str();
#else
            return (format("failed due to signal %1%") % sig).str();
#endif
        }
        else
            return "died abnormally";
    } else return "succeeded";
}


bool statusOk(int status)
{
    return WIFEXITED(status) && WEXITSTATUS(status) == 0;
}


bool hasPrefix(const string & s, const string & suffix)
{
    return s.compare(0, suffix.size(), suffix) == 0;
}


bool hasSuffix(const string & s, const string & suffix)
{
    return s.size() >= suffix.size() && string(s, s.size() - suffix.size()) == suffix;
}


std::string toLower(const std::string & s)
{
    std::string r(s);
    for (auto & c : r)
        c = std::tolower(c);
    return r;
}


string decodeOctalEscaped(const string & s)
{
    string r;
    for (string::const_iterator i = s.begin(); i != s.end(); ) {
        if (*i != '\\') { r += *i++; continue; }
        unsigned char c = 0;
        ++i;
        while (i != s.end() && *i >= '0' && *i < '8')
            c = c * 8 + (*i++ - '0');
        r += c;
    }
    return r;
}


void ignoreException()
{
    try {
        throw;
    } catch (std::exception & e) {
        printError(format("error (ignored): %1%") % e.what());
    }
}


string filterANSIEscapes(const string & s, bool nixOnly)
{
    string t, r;
    enum { stTop, stEscape, stCSI } state = stTop;
    for (auto c : s) {
        if (state == stTop) {
            if (c == '\e') {
                state = stEscape;
                r = c;
            } else
                t += c;
        } else if (state == stEscape) {
            r += c;
            if (c == '[')
                state = stCSI;
            else {
                t += r;
                state = stTop;
            }
        } else {
            r += c;
            if (c >= 0x40 && c != 0x7e) {
                if (nixOnly && (c != 'p' && c != 'q' && c != 's' && c != 'a' && c != 'b'))
                    t += r;
                state = stTop;
                r.clear();
            }
        }
    }
    t += r;
    return t;
}


static char base64Chars[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


string base64Encode(const string & s)
{
    string res;
    int data = 0, nbits = 0;

    for (char c : s) {
        data = data << 8 | (unsigned char) c;
        nbits += 8;
        while (nbits >= 6) {
            nbits -= 6;
            res.push_back(base64Chars[data >> nbits & 0x3f]);
        }
    }

    if (nbits) res.push_back(base64Chars[data << (6 - nbits) & 0x3f]);
    while (res.size() % 4) res.push_back('=');

    return res;
}


string base64Decode(const string & s)
{
    bool init = false;
    char decode[256];
    if (!init) {
        // FIXME: not thread-safe.
        memset(decode, -1, sizeof(decode));
        for (int i = 0; i < 64; i++)
            decode[(int) base64Chars[i]] = i;
        init = true;
    }

    string res;
    unsigned int d = 0, bits = 0;

    for (char c : s) {
        if (c == '=') break;
        if (c == '\n') continue;

        char digit = decode[(unsigned char) c];
        if (digit == -1)
            throw Error("invalid character in Base64 string");

        bits += 6;
        d = d << 6 | digit;
        if (bits >= 8) {
            res.push_back(d >> (bits - 8) & 0xff);
            bits -= 8;
        }
    }

    return res;
}


void callFailure(const std::function<void(std::exception_ptr exc)> & failure, std::exception_ptr exc)
{
    try {
        failure(exc);
    } catch (std::exception & e) {
        printError(format("uncaught exception: %s") % e.what());
        abort();
    }
}


static Sync<std::list<std::function<void()>>> _interruptCallbacks;

static void signalHandlerThread(sigset_t set)
{
    while (true) {
        int signal = 0;
        sigwait(&set, &signal);

        if (signal == SIGINT || signal == SIGTERM || signal == SIGHUP)
            triggerInterrupt();
    }
}

void triggerInterrupt()
{
    _isInterrupted = true;

    {
        auto interruptCallbacks(_interruptCallbacks.lock());
        for (auto & callback : *interruptCallbacks) {
            try {
                callback();
            } catch (...) {
                ignoreException();
            }
        }
    }
}

static sigset_t savedSignalMask;

void startSignalHandlerThread()
{
    if (sigprocmask(SIG_BLOCK, nullptr, &savedSignalMask))
        throw SysError("quering signal mask");

    sigset_t set;
    sigemptyset(&set);
    sigaddset(&set, SIGINT);
    sigaddset(&set, SIGTERM);
    sigaddset(&set, SIGHUP);
    sigaddset(&set, SIGPIPE);
    if (pthread_sigmask(SIG_BLOCK, &set, nullptr))
        throw SysError("blocking signals");

    std::thread(signalHandlerThread, set).detach();
}

void restoreSignals()
{
    if (sigprocmask(SIG_SETMASK, &savedSignalMask, nullptr))
        throw SysError("restoring signals");
}

/* RAII helper to automatically deregister a callback. */
struct InterruptCallbackImpl : InterruptCallback
{
    std::list<std::function<void()>>::iterator it;
    ~InterruptCallbackImpl() override
    {
        _interruptCallbacks.lock()->erase(it);
    }
};

std::unique_ptr<InterruptCallback> createInterruptCallback(std::function<void()> callback)
{
    auto interruptCallbacks(_interruptCallbacks.lock());
    interruptCallbacks->push_back(callback);

    auto res = std::make_unique<InterruptCallbackImpl>();
    res->it = interruptCallbacks->end();
    res->it--;

    return std::unique_ptr<InterruptCallback>(res.release());
}

}