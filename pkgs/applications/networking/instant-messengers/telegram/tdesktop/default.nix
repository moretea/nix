{ mkDerivation, lib, fetchgit, pkgconfig, gyp, cmake
, qtbase, qtimageformats
, breakpad, gtk3, libappindicator-gtk3, dee
, ffmpeg, openalSoft, minizip, libopus, alsaLib, libpulseaudio
, gcc
}:

mkDerivation rec {
  name = "telegram-desktop-${version}";
  version = "1.1.19";

  # Submodules
  src = fetchgit {
    url = "git://github.com/telegramdesktop/tdesktop";
    rev = "v${version}";
    sha256 = "1zpl71k2lq861k89yp6nzkm4jm6szxrzigmmbxx63rh4v03di3b6";
    fetchSubmodules = true;
  };

  tgaur = fetchgit {
    url = "https://aur.archlinux.org/telegram-desktop-systemqt.git";
    rev = "a4ba392309116003bc2b75c1c4c12dc733168d6f";
    sha256 = "1n0yar8pm050770x36kjr4iap773xjigfbnrk289b51i5vijwhsv";
  };

  buildInputs = [
    gtk3 libappindicator-gtk3 dee qtbase qtimageformats ffmpeg openalSoft minizip
    libopus alsaLib libpulseaudio
  ];

  nativeBuildInputs = [ pkgconfig gyp cmake gcc ];

  patches = [ "${tgaur}/tdesktop.patch" ];

  enableParallelBuilding = true;

  GYP_DEFINES = lib.concatStringsSep "," [
    "TDESKTOP_DISABLE_CRASH_REPORTS"
    "TDESKTOP_DISABLE_AUTOUPDATE"
    "TDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
  ];

  NIX_CFLAGS_COMPILE = [
    "-DTDESKTOP_DISABLE_AUTOUPDATE"
    "-DTDESKTOP_DISABLE_CRASH_REPORTS"
    "-DTDESKTOP_DISABLE_REGISTER_CUSTOM_SCHEME"
    "-I${minizip}/include/minizip"
    # See Telegram/gyp/qt.gypi
    "-I${qtbase.dev}/mkspecs/linux-g++"
  ] ++ lib.concatMap (x: [
    "-I${qtbase.dev}/include/${x}"
    "-I${qtbase.dev}/include/${x}/${qtbase.version}"
    "-I${qtbase.dev}/include/${x}/${qtbase.version}/${x}"
    "-I${libopus.dev}/include/opus"
    "-I${alsaLib.dev}/include/alsa"
    "-I${libpulseaudio.dev}/include/pulse"
  ]) [ "QtCore" "QtGui" ];
  CPPFLAGS = NIX_CFLAGS_COMPILE;

  preConfigure = ''

    pushd "Telegram/ThirdParty/libtgvoip"
    patch -Np1 -i "${tgaur}/libtgvoip.patch"
    popd

    sed -i Telegram/gyp/telegram_linux.gypi \
      -e 's,/usr,/does-not-exist,g' \
      -e 's,appindicator-0.1,appindicator3-0.1,g' \
      -e 's,-flto,,g'

    sed -i Telegram/gyp/qt.gypi \
      -e "s,/usr/bin/moc,moc,g"
    sed -i Telegram/gyp/qt_rcc.gypi \
      -e "s,/usr/bin/rcc,rcc,g"

    gyp \
      -Dbuild_defines=${GYP_DEFINES} \
      -Gconfig=Release \
      --depth=Telegram/gyp \
      --generator-output=../.. \
      -Goutput_dir=out \
       --format=cmake \
      Telegram/gyp/Telegram.gyp

    cd out/Release

    NUM=$((`wc -l < CMakeLists.txt` - 2))
    sed -i "$NUM r $tgaur/CMakeLists.inj" CMakeLists.txt

    export ASM=$(type -p gcc)
  '';

  installPhase = ''
    install -Dm755 Telegram $out/bin/telegram-desktop
    mkdir -p $out/share/applications $out/share/kde4/services
    sed "s,/usr/bin,$out/bin,g" $tgaur/telegramdesktop.desktop > $out/share/applications/telegramdesktop.desktop
    sed "s,/usr/bin,$out/bin,g" $tgaur/tg.protocol > $out/share/kde4/services/tg.protocol
    for icon_size in 16 32 48 64 128 256 512; do
      install -Dm644 "../../../Telegram/Resources/art/icon''${icon_size}.png" "$out/share/icons/hicolor/''${icon_size}x''${icon_size}/apps/telegram-desktop.png"
    done
  '';

  meta = with lib; {
    description = "Telegram Desktop messaging app";
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = https://desktop.telegram.org/;
    maintainers = with maintainers; [ abbradar garbas ];
  };
}