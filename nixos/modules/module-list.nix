[
  ./config/debug-info.nix
  ./config/fonts/corefonts.nix
  ./config/fonts/fontconfig-ultimate.nix
  ./config/fonts/fontconfig.nix
  ./config/fonts/fontdir.nix
  ./config/fonts/fonts.nix
  ./config/fonts/ghostscript.nix
  ./config/gnu.nix
  ./config/i18n.nix
  ./config/krb5.nix
  ./config/ldap.nix
  ./config/networking.nix
  ./config/no-x-libs.nix
  ./config/nsswitch.nix
  ./config/power-management.nix
  ./config/pulseaudio.nix
  ./config/shells-environment.nix
  ./config/swap.nix
  ./config/sysctl.nix
  ./config/system-environment.nix
  ./config/system-path.nix
  ./config/timezone.nix
  ./config/unix-odbc-drivers.nix
  ./config/users-groups.nix
  ./config/vpnc.nix
  ./config/zram.nix
  ./hardware/all-firmware.nix
  ./hardware/ckb.nix
  ./hardware/cpu/amd-microcode.nix
  ./hardware/cpu/intel-microcode.nix
  ./hardware/ksm.nix
  ./hardware/mcelog.nix
  ./hardware/network/b43.nix
  ./hardware/network/intel-2100bg.nix
  ./hardware/network/intel-2200bg.nix
  ./hardware/network/intel-3945abg.nix
  ./hardware/network/ralink.nix
  ./hardware/network/rtl8192c.nix
  ./hardware/opengl.nix
  ./hardware/pcmcia.nix
  ./hardware/usb-wwan.nix
  ./hardware/video/amdgpu.nix
  ./hardware/video/amdgpu-pro.nix
  ./hardware/video/ati.nix
  ./hardware/video/capture/mwprocapture.nix
  ./hardware/video/bumblebee.nix
  ./hardware/video/displaylink.nix
  ./hardware/video/nvidia.nix
  ./hardware/video/webcam/facetimehd.nix
  ./i18n/input-method/default.nix
  ./i18n/input-method/fcitx.nix
  ./i18n/input-method/ibus.nix
  ./i18n/input-method/nabi.nix
  ./i18n/input-method/uim.nix
  ./installer/tools/auto-upgrade.nix
  ./installer/tools/tools.nix
  ./misc/assertions.nix
  ./misc/crashdump.nix
  ./misc/extra-arguments.nix
  ./misc/ids.nix
  ./misc/lib.nix
  ./misc/locate.nix
  ./misc/meta.nix
  ./misc/nixpkgs.nix
  ./misc/passthru.nix
  ./misc/version.nix
  ./programs/adb.nix
  ./programs/atop.nix
  ./programs/bash/bash.nix
  ./programs/blcr.nix
  ./programs/cdemu.nix
  ./programs/chromium.nix
  ./programs/command-not-found/command-not-found.nix
  ./programs/dconf.nix
  ./programs/environment.nix
  ./programs/fish.nix
  ./programs/freetds.nix
  ./programs/gphoto2.nix
  ./programs/info.nix
  ./programs/java.nix
  ./programs/kbdlight.nix
  ./programs/light.nix
  ./programs/man.nix
  ./programs/mosh.nix
  ./programs/mtr.nix
  ./programs/nano.nix
  ./programs/oblogout.nix
  ./programs/screen.nix
  ./programs/shadow.nix
  ./programs/shell.nix
  ./programs/spacefm.nix
  ./programs/ssh.nix
  ./programs/ssmtp.nix
  ./programs/tmux.nix
  ./programs/venus.nix
  ./programs/vim.nix
  ./programs/wireshark.nix
  ./programs/wvdial.nix
  ./programs/xfs_quota.nix
  ./programs/xonsh.nix
  ./programs/zsh/zsh.nix
  ./rename.nix
  ./security/acme.nix
  ./security/apparmor.nix
  ./security/apparmor-suid.nix
  ./security/audit.nix
  ./security/ca.nix
  ./security/chromium-suid-sandbox.nix
  ./security/dhparams.nix
  ./security/duosec.nix
  ./security/grsecurity.nix
  ./security/hidepid.nix
  ./security/oath.nix
  ./security/pam.nix
  ./security/pam_usb.nix
  ./security/pam_mount.nix
  ./security/polkit.nix
  ./security/prey.nix
  ./security/rngd.nix
  ./security/rtkit.nix
  ./security/wrappers/default.nix
  ./security/sudo.nix
  ./services/amqp/activemq/default.nix
  ./services/amqp/rabbitmq.nix
  ./services/audio/alsa.nix
  ./services/audio/icecast.nix
  ./services/audio/liquidsoap.nix
  ./services/audio/mpd.nix
  ./services/audio/mopidy.nix
  ./services/audio/squeezelite.nix
  ./services/audio/ympd.nix
  ./services/backup/almir.nix
  ./services/backup/bacula.nix
  ./services/backup/crashplan.nix
  ./services/backup/mysql-backup.nix
  ./services/backup/postgresql-backup.nix
  ./services/backup/rsnapshot.nix
  ./services/backup/sitecopy-backup.nix
  ./services/backup/tarsnap.nix
  ./services/backup/znapzend.nix
  ./services/cluster/fleet.nix
  ./services/cluster/kubernetes.nix
  ./services/cluster/panamax.nix
  ./services/computing/boinc/client.nix
  ./services/computing/torque/server.nix
  ./services/computing/torque/mom.nix
  ./services/computing/slurm/slurm.nix
  ./services/continuous-integration/buildbot/master.nix
  ./services/continuous-integration/buildbot/worker.nix
  ./services/continuous-integration/buildkite-agent.nix
  ./services/continuous-integration/hydra/default.nix
  ./services/continuous-integration/gitlab-runner.nix
  ./services/continuous-integration/gocd-agent/default.nix
  ./services/continuous-integration/gocd-server/default.nix
  ./services/continuous-integration/jenkins/default.nix
  ./services/continuous-integration/jenkins/job-builder.nix
  ./services/continuous-integration/jenkins/slave.nix
  ./services/databases/4store-endpoint.nix
  ./services/databases/4store.nix
  ./services/databases/couchdb.nix
  ./services/databases/firebird.nix
  ./services/databases/hbase.nix
  ./services/databases/influxdb.nix
  ./services/databases/memcached.nix
  ./services/databases/mongodb.nix
  ./services/databases/mysql.nix
  ./services/databases/neo4j.nix
  ./services/databases/openldap.nix
  ./services/databases/opentsdb.nix
  ./services/databases/postgresql.nix
  ./services/databases/redis.nix
  ./services/databases/riak.nix
  ./services/databases/riak-cs.nix
  ./services/databases/stanchion.nix
  ./services/databases/virtuoso.nix
  ./services/desktops/accountsservice.nix
  ./services/desktops/geoclue2.nix
  ./services/desktops/gnome3/at-spi2-core.nix
  ./services/desktops/gnome3/evolution-data-server.nix
  ./services/desktops/gnome3/gnome-documents.nix
  ./services/desktops/gnome3/gnome-keyring.nix
  ./services/desktops/gnome3/gnome-online-accounts.nix
  ./services/desktops/gnome3/gnome-online-miners.nix
  ./services/desktops/gnome3/gnome-terminal-server.nix
  ./services/desktops/gnome3/gnome-user-share.nix
  ./services/desktops/gnome3/gvfs.nix
  ./services/desktops/gnome3/seahorse.nix
  ./services/desktops/gnome3/sushi.nix
  ./services/desktops/gnome3/tracker.nix
  ./services/desktops/profile-sync-daemon.nix
  ./services/desktops/telepathy.nix
  ./services/development/hoogle.nix
  ./services/editors/emacs.nix
  ./services/editors/infinoted.nix
  ./services/games/factorio.nix
  ./services/games/ghost-one.nix
  ./services/games/minecraft-server.nix
  ./services/games/minetest-server.nix
  ./services/games/terraria.nix
  ./services/hardware/acpid.nix
  ./services/hardware/actkbd.nix
  ./services/hardware/amd-hybrid-graphics.nix
  ./services/hardware/bluetooth.nix
  ./services/hardware/brltty.nix
  ./services/hardware/freefall.nix
  ./services/hardware/illum.nix
  ./services/hardware/irqbalance.nix
  ./services/hardware/nvidia-optimus.nix
  ./services/hardware/pcscd.nix
  ./services/hardware/pommed.nix
  ./services/hardware/sane.nix
  ./services/hardware/tcsd.nix
  ./services/hardware/tlp.nix
  ./services/hardware/thinkfan.nix
  ./services/hardware/trezord.nix
  ./services/hardware/udev.nix
  ./services/hardware/udisks2.nix
  ./services/hardware/upower.nix
  ./services/hardware/thermald.nix
  ./services/logging/awstats.nix
  ./services/logging/fluentd.nix
  ./services/logging/graylog.nix
  ./services/logging/journalbeat.nix
  ./services/logging/klogd.nix
  ./services/logging/logcheck.nix
  ./services/logging/logrotate.nix
  ./services/logging/logstash.nix
  ./services/logging/rsyslogd.nix
  ./services/logging/syslogd.nix
  ./services/logging/syslog-ng.nix
  ./services/mail/dovecot.nix
  ./services/mail/dspam.nix
  ./services/mail/exim.nix
  ./services/mail/freepops.nix
  ./services/mail/mail.nix
  ./services/mail/mlmmj.nix
  ./services/mail/offlineimap.nix
  ./services/mail/opendkim.nix
  ./services/mail/opensmtpd.nix
  ./services/mail/postfix.nix
  ./services/mail/postsrsd.nix
  ./services/mail/postgrey.nix
  ./services/mail/spamassassin.nix
  ./services/mail/rspamd.nix
  ./services/mail/rmilter.nix
  ./services/misc/apache-kafka.nix
  ./services/misc/autofs.nix
  ./services/misc/bepasty.nix
  ./services/misc/canto-daemon.nix
  ./services/misc/calibre-server.nix
  ./services/misc/cfdyndns.nix
  ./services/misc/cpuminer-cryptonight.nix
  ./services/misc/cgminer.nix
  ./services/misc/confd.nix
  ./services/misc/couchpotato.nix
  ./services/misc/devmon.nix
  ./services/misc/dictd.nix
  ./services/misc/dysnomia.nix
  ./services/misc/disnix.nix
  ./services/misc/docker-registry.nix
  ./services/misc/emby.nix
  ./services/misc/errbot.nix
  ./services/misc/etcd.nix
  ./services/misc/felix.nix
  ./services/misc/folding-at-home.nix
  ./services/misc/gammu-smsd.nix
  ./services/misc/geoip-updater.nix
  #./services/misc/gitit.nix
  ./services/misc/gitlab.nix
  ./services/misc/gitolite.nix
  ./services/misc/gogs.nix
  ./services/misc/gpsd.nix
  #./services/misc/ihaskell.nix
  ./services/misc/leaps.nix
  ./services/misc/mantisbt.nix
  ./services/misc/mathics.nix
  ./services/misc/matrix-synapse.nix
  ./services/misc/mbpfan.nix
  ./services/misc/mediatomb.nix
  ./services/misc/mesos-master.nix
  ./services/misc/mesos-slave.nix
  ./services/misc/mwlib.nix
  ./services/misc/nix-daemon.nix
  ./services/misc/nix-gc.nix
  ./services/misc/nix-optimise.nix
  ./services/misc/nixos-manual.nix
  ./services/misc/nix-ssh-serve.nix
  ./services/misc/nzbget.nix
  ./services/misc/octoprint.nix
  ./services/misc/packagekit.nix
  ./services/misc/parsoid.nix
  ./services/misc/phd.nix
  ./services/misc/plex.nix
  ./services/misc/redmine.nix
  ./services/misc/rippled.nix
  ./services/misc/ripple-rest.nix
  ./services/misc/ripple-data-api.nix
  ./services/misc/rogue.nix
  ./services/misc/siproxd.nix
  ./services/misc/sonarr.nix
  ./services/misc/spice-vdagentd.nix
  ./services/misc/ssm-agent.nix
  ./services/misc/sssd.nix
  ./services/misc/subsonic.nix
  ./services/misc/sundtek.nix
  ./services/misc/svnserve.nix
  ./services/misc/synergy.nix
  ./services/misc/taskserver
  ./services/misc/uhub.nix
  ./services/misc/zookeeper.nix
  ./services/monitoring/apcupsd.nix
  ./services/monitoring/arbtt.nix
  ./services/monitoring/bosun.nix
  ./services/monitoring/cadvisor.nix
  ./services/monitoring/collectd.nix
  ./services/monitoring/das_watchdog.nix
  ./services/monitoring/dd-agent.nix
  ./services/monitoring/grafana.nix
  ./services/monitoring/graphite.nix
  ./services/monitoring/hdaps.nix
  ./services/monitoring/heapster.nix
  ./services/monitoring/longview.nix
  ./services/monitoring/monit.nix
  ./services/monitoring/munin.nix
  ./services/monitoring/nagios.nix
  ./services/monitoring/netdata.nix
  ./services/monitoring/prometheus/default.nix
  ./services/monitoring/prometheus/alertmanager.nix
  ./services/monitoring/prometheus/blackbox-exporter.nix
  ./services/monitoring/prometheus/json-exporter.nix
  ./services/monitoring/prometheus/nginx-exporter.nix
  ./services/monitoring/prometheus/node-exporter.nix
  ./services/monitoring/prometheus/snmp-exporter.nix
  ./services/monitoring/prometheus/varnish-exporter.nix
  ./services/monitoring/riemann.nix
  ./services/monitoring/riemann-dash.nix
  ./services/monitoring/riemann-tools.nix
  ./services/monitoring/scollector.nix
  ./services/monitoring/smartd.nix
  ./services/monitoring/statsd.nix
  ./services/monitoring/sysstat.nix
  ./services/monitoring/systemhealth.nix
  ./services/monitoring/teamviewer.nix
  ./services/monitoring/telegraf.nix
  ./services/monitoring/ups.nix
  ./services/monitoring/uptime.nix
  ./services/monitoring/vnstat.nix
  ./services/monitoring/zabbix-agent.nix
  ./services/monitoring/zabbix-server.nix
  ./services/network-filesystems/cachefilesd.nix
  ./services/network-filesystems/drbd.nix
  ./services/network-filesystems/glusterfs.nix
  ./services/network-filesystems/ipfs.nix
  ./services/network-filesystems/netatalk.nix
  ./services/network-filesystems/nfsd.nix
  ./services/network-filesystems/openafs-client/default.nix
  ./services/network-filesystems/rsyncd.nix
  ./services/network-filesystems/samba.nix
  ./services/network-filesystems/tahoe.nix
  ./services/network-filesystems/diod.nix
  ./services/network-filesystems/u9fs.nix
  ./services/network-filesystems/yandex-disk.nix
  ./services/network-filesystems/xtreemfs.nix
  ./services/networking/aiccu.nix
  ./services/networking/amuled.nix
  ./services/networking/asterisk.nix
  ./services/networking/atftpd.nix
  ./services/networking/avahi-daemon.nix
  ./services/networking/bind.nix
  ./services/networking/autossh.nix
  ./services/networking/bird.nix
  ./services/networking/bitlbee.nix
  ./services/networking/btsync.nix
  ./services/networking/charybdis.nix
  ./services/networking/chrony.nix
  ./services/networking/cjdns.nix
  ./services/networking/cntlm.nix
  ./services/networking/connman.nix
  ./services/networking/consul.nix
  ./services/networking/coturn.nix
  ./services/networking/dante.nix
  ./services/networking/ddclient.nix
  ./services/networking/dhcpcd.nix
  ./services/networking/dhcpd.nix
  ./services/networking/dnschain.nix
  ./services/networking/dnscrypt-proxy.nix
  ./services/networking/dnscrypt-wrapper.nix
  ./services/networking/dnsmasq.nix
  ./services/networking/ejabberd.nix
  ./services/networking/fan.nix
  ./services/networking/fakeroute.nix
  ./services/networking/ferm.nix
  ./services/networking/firefox/sync-server.nix
  ./services/networking/firewall.nix
  ./services/networking/flannel.nix
  ./services/networking/flashpolicyd.nix
  ./services/networking/freenet.nix
  ./services/networking/gale.nix
  ./services/networking/gateone.nix
  ./services/networking/gdomap.nix
  ./services/networking/git-daemon.nix
  ./services/networking/gnunet.nix
  ./services/networking/gogoclient.nix
  ./services/networking/gvpe.nix
  ./services/networking/haproxy.nix
  ./services/networking/heyefi.nix
  ./services/networking/hostapd.nix
  ./services/networking/htpdate.nix
  ./services/networking/i2pd.nix
  ./services/networking/i2p.nix
  ./services/networking/iodine.nix
  ./services/networking/ircd-hybrid/default.nix
  ./services/networking/kippo.nix
  ./services/networking/kresd.nix
  ./services/networking/lambdabot.nix
  ./services/networking/libreswan.nix
  ./services/networking/logmein-hamachi.nix
  ./services/networking/mailpile.nix
  ./services/networking/mfi.nix
  ./services/networking/mjpg-streamer.nix
  ./services/networking/minidlna.nix
  ./services/networking/miniupnpd.nix
  ./services/networking/mosquitto.nix
  ./services/networking/miredo.nix
  ./services/networking/mstpd.nix
  ./services/networking/murmur.nix
  ./services/networking/namecoind.nix
  ./services/networking/nat.nix
  ./services/networking/networkmanager.nix
  ./services/networking/nftables.nix
  ./services/networking/ngircd.nix
  ./services/networking/nix-serve.nix
  ./services/networking/nntp-proxy.nix
  ./services/networking/nsd.nix
  ./services/networking/ntopng.nix
  ./services/networking/ntpd.nix
  ./services/networking/nylon.nix
  ./services/networking/oidentd.nix
  ./services/networking/openfire.nix
  ./services/networking/openntpd.nix
  ./services/networking/openvpn.nix
  ./services/networking/ostinato.nix
  ./services/networking/pdnsd.nix
  ./services/networking/polipo.nix
  ./services/networking/powerdns.nix
  ./services/networking/pdns-recursor.nix
  ./services/networking/pptpd.nix
  ./services/networking/prayer.nix
  ./services/networking/privoxy.nix
  ./services/networking/prosody.nix
  ./services/networking/quagga.nix
  ./services/networking/quassel.nix
  ./services/networking/racoon.nix
  ./services/networking/radicale.nix
  ./services/networking/radvd.nix
  ./services/networking/rdnssd.nix
  ./services/networking/redsocks.nix
  ./services/networking/rpcbind.nix
  ./services/networking/sabnzbd.nix
  ./services/networking/searx.nix
  ./services/networking/seeks.nix
  ./services/networking/skydns.nix
  ./services/networking/shairport-sync.nix
  ./services/networking/shout.nix
  ./services/networking/sniproxy.nix
  ./services/networking/smokeping.nix
  ./services/networking/softether.nix
  ./services/networking/spiped.nix
  ./services/networking/sslh.nix
  ./services/networking/ssh/lshd.nix
  ./services/networking/ssh/sshd.nix
  ./services/networking/strongswan.nix
  ./services/networking/supplicant.nix
  ./services/networking/supybot.nix
  ./services/networking/syncthing.nix
  ./services/networking/tcpcrypt.nix
  ./services/networking/teamspeak3.nix
  ./services/networking/tinc.nix
  ./services/networking/tftpd.nix
  ./services/networking/tlsdated.nix
  ./services/networking/tox-bootstrapd.nix
  ./services/networking/toxvpn.nix
  ./services/networking/tvheadend.nix
  ./services/networking/unbound.nix
  ./services/networking/unifi.nix
  ./services/networking/vsftpd.nix
  ./services/networking/wakeonlan.nix
  ./services/networking/websockify.nix
  ./services/networking/wicd.nix
  ./services/networking/wireguard.nix
  ./services/networking/wpa_supplicant.nix
  ./services/networking/xinetd.nix
  ./services/networking/xl2tpd.nix
  ./services/networking/zerobin.nix
  ./services/networking/zerotierone.nix
  ./services/networking/znc.nix
  ./services/printing/cupsd.nix
  ./services/scheduling/atd.nix
  ./services/scheduling/chronos.nix
  ./services/scheduling/cron.nix
  ./services/scheduling/fcron.nix
  ./services/scheduling/marathon.nix
  ./services/search/elasticsearch.nix
  ./services/search/hound.nix
  ./services/search/kibana.nix
  ./services/search/solr.nix
  ./services/security/clamav.nix
  ./services/security/fail2ban.nix
  ./services/security/fprintd.nix
  ./services/security/fprot.nix
  ./services/security/frandom.nix
  ./services/security/haka.nix
  ./services/security/haveged.nix
  ./services/security/hologram-server.nix
  ./services/security/hologram-agent.nix
  ./services/security/munge.nix
  ./services/security/oauth2_proxy.nix
  ./services/security/physlock.nix
  ./services/security/torify.nix
  ./services/security/tor.nix
  ./services/security/torsocks.nix
  ./services/system/cgmanager.nix
  ./services/system/cloud-init.nix
  ./services/system/dbus.nix
  ./services/system/kerberos.nix
  ./services/system/nscd.nix
  ./services/system/uptimed.nix
  ./services/torrent/deluge.nix
  ./services/torrent/flexget.nix
  ./services/torrent/opentracker.nix
  ./services/torrent/peerflix.nix
  ./services/torrent/transmission.nix
  ./services/ttys/agetty.nix
  ./services/ttys/gpm.nix
  ./services/ttys/kmscon.nix
  ./services/web-apps/atlassian/confluence.nix
  ./services/web-apps/atlassian/crowd.nix
  ./services/web-apps/atlassian/jira.nix
  ./services/web-apps/frab.nix
  ./services/web-apps/mattermost.nix
  ./services/web-apps/nixbot.nix
  ./services/web-apps/pump.io.nix
  ./services/web-apps/tt-rss.nix
  ./services/web-apps/selfoss.nix
  ./services/web-apps/quassel-webserver.nix
  ./services/web-servers/apache-httpd/default.nix
  ./services/web-servers/caddy.nix
  ./services/web-servers/fcgiwrap.nix
  ./services/web-servers/jboss/default.nix
  ./services/web-servers/lighttpd/cgit.nix
  ./services/web-servers/lighttpd/default.nix
  ./services/web-servers/lighttpd/gitweb.nix
  ./services/web-servers/lighttpd/inginious.nix
  ./services/web-servers/nginx/default.nix
  ./services/web-servers/phpfpm/default.nix
  ./services/web-servers/shellinabox.nix
  ./services/web-servers/tomcat.nix
  ./services/web-servers/uwsgi.nix
  ./services/web-servers/varnish/default.nix
  ./services/web-servers/winstone.nix
  ./services/web-servers/zope2.nix
  ./services/x11/colord.nix
  ./services/x11/compton.nix
  ./services/x11/unclutter.nix
  ./services/x11/unclutter-xfixes.nix
  ./services/x11/desktop-managers/default.nix
  ./services/x11/display-managers/auto.nix
  ./services/x11/display-managers/default.nix
  ./services/x11/display-managers/gdm.nix
  ./services/x11/display-managers/lightdm.nix
  ./services/x11/display-managers/sddm.nix
  ./services/x11/display-managers/slim.nix
  ./services/x11/hardware/libinput.nix
  ./services/x11/hardware/multitouch.nix
  ./services/x11/hardware/synaptics.nix
  ./services/x11/hardware/wacom.nix
  ./services/x11/redshift.nix
  ./services/x11/urxvtd.nix
  ./services/x11/window-managers/awesome.nix
  #./services/x11/window-managers/compiz.nix
  ./services/x11/window-managers/default.nix
  ./services/x11/window-managers/fluxbox.nix
  ./services/x11/window-managers/icewm.nix
  ./services/x11/window-managers/bspwm.nix
  ./services/x11/window-managers/metacity.nix
  ./services/x11/window-managers/none.nix
  ./services/x11/window-managers/twm.nix
  ./services/x11/window-managers/windowlab.nix
  ./services/x11/window-managers/wmii.nix
  ./services/x11/window-managers/xmonad.nix
  ./services/x11/xbanish.nix
  ./services/x11/xfs.nix
  ./services/x11/xserver.nix
  ./system/activation/activation-script.nix
  ./system/activation/top-level.nix
  ./system/boot/coredump.nix
  ./system/boot/emergency-mode.nix
  ./system/boot/initrd-network.nix
  ./system/boot/initrd-ssh.nix
  ./system/boot/kernel.nix
  ./system/boot/kexec.nix
  ./system/boot/loader/efi.nix
  ./system/boot/loader/generations-dir/generations-dir.nix
  ./system/boot/loader/generic-extlinux-compatible
  ./system/boot/loader/grub/grub.nix
  ./system/boot/loader/grub/ipxe.nix
  ./system/boot/loader/grub/memtest.nix
  ./system/boot/loader/init-script/init-script.nix
  ./system/boot/loader/loader.nix
  ./system/boot/loader/raspberrypi/raspberrypi.nix
  ./system/boot/loader/systemd-boot/systemd-boot.nix
  ./system/boot/luksroot.nix
  ./system/boot/modprobe.nix
  ./system/boot/networkd.nix
  ./system/boot/plymouth.nix
  ./system/boot/resolved.nix
  ./system/boot/shutdown.nix
  ./system/boot/stage-1.nix
  ./system/boot/stage-2.nix
  ./system/boot/systemd.nix
  ./system/boot/systemd-nspawn.nix
  ./system/boot/timesyncd.nix
  ./system/boot/tmp.nix
  ./system/etc/etc.nix
  ./tasks/bcache.nix
  ./tasks/cpu-freq.nix
  ./tasks/encrypted-devices.nix
  ./tasks/filesystems.nix
  ./tasks/filesystems/btrfs.nix
  ./tasks/filesystems/cifs.nix
  ./tasks/filesystems/exfat.nix
  ./tasks/filesystems/ext.nix
  ./tasks/filesystems/f2fs.nix
  ./tasks/filesystems/jfs.nix
  ./tasks/filesystems/nfs.nix
  ./tasks/filesystems/ntfs.nix
  ./tasks/filesystems/reiserfs.nix
  ./tasks/filesystems/unionfs-fuse.nix
  ./tasks/filesystems/vboxsf.nix
  ./tasks/filesystems/vfat.nix
  ./tasks/filesystems/xfs.nix
  ./tasks/filesystems/zfs.nix
  ./tasks/kbd.nix
  ./tasks/lvm.nix
  ./tasks/network-interfaces.nix
  ./tasks/network-interfaces-systemd.nix
  ./tasks/network-interfaces-scripted.nix
  ./tasks/scsi-link-power-management.nix
  ./tasks/swraid.nix
  ./tasks/trackpoint.nix
  ./testing/service-runner.nix
  ./virtualisation/container-config.nix
  ./virtualisation/containers.nix
  ./virtualisation/docker.nix
  ./virtualisation/ecs-agent.nix
  ./virtualisation/libvirtd.nix
  ./virtualisation/lxc.nix
  ./virtualisation/lxcfs.nix
  ./virtualisation/lxd.nix
  ./virtualisation/amazon-options.nix
  ./virtualisation/openvswitch.nix
  ./virtualisation/parallels-guest.nix
  ./virtualisation/rkt.nix
  ./virtualisation/virtualbox-guest.nix
  ./virtualisation/virtualbox-host.nix
  ./virtualisation/vmware-guest.nix
  ./virtualisation/xen-dom0.nix
  ./virtualisation/xe-guest-utilities.nix
  ./virtualisation/openstack/keystone.nix
  ./virtualisation/openstack/glance.nix
]