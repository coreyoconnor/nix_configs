{ fetchurl, lib, stdenv, squashfsTools, xorg, alsa-lib, makeShellWrapper, wrapGAppsHook, openssl, freetype
, glib, pango, cairo, atk, gdk-pixbuf, gtk3, cups, nspr, nss_latest, libpng, libnotify
, libgcrypt, systemd, fontconfig, dbus, expat, curlWithGnuTls, zlib, gnome
, at-spi2-atk, at-spi2-core, libdrm, mesa, libxkbcommon
, harfbuzz, libsecret
  # High-DPI support: Spotify's --force-device-scale-factor argument
  # not added if `null`, otherwise, should be a number.
, deviceScaleFactor ? null
}:

let
  version = "5.7.23";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curlWithGnuTls
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdrm
    libgcrypt
    libnotify
    libpng
    libsecret
    libxkbcommon
    mesa
    nss_latest
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    zlib
  ];

in

stdenv.mkDerivation {
  pname = "nordpass";

  inherit version;

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/00CQ2MvSr0Ex7zwdGhCYTa0ZLMw3H6hf_168.snap";
    sha256 = "b6c36996cb0287c18e704426b983dfcbfa5bfdef86ff8ef8b88f6f63556afaad";
  };

  nativeBuildInputs = [ wrapGAppsHook makeShellWrapper squashfsTools ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    runHook postUnpack
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  installPhase =
    ''
      runHook preInstall
      
      libdirs="$out/opt/nordpass/lib/x86_64-linux-gnu/lib:$out/opt/nordpass/usr/lib/x86_64-linux-gnu"

      mkdir -p $out/opt/nordpass
      cp -r . $out/opt/nordpass/

      rpath="$out/opt/nordpass:$libdirs"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/opt/nordpass/nordpass

      librarypath="${lib.makeLibraryPath deps}:$libdirs"
      wrapProgramShell $out/opt/nordpass/nordpass \
        ''${gappsWrapperArgs[@]} \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

      mkdir -p $out/bin
      ln -s $out/opt/nordpass/nordpass $out/bin/nordpass

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/opt/nordpass/meta/gui/nordpass.desktop" "$out/share/applications/"

      runHook postInstall
    '';

  meta = {
    maintainers = with lib.maintainers; [ coreyoconnor ];
  };
}
