self: super: rec {
  mesa = super.mesa.override {
    galliumDrivers = [ "auto" "swr" ];
  };

  xspice-server-config = self.writeTextFile {
    name = "xspice-server.conf";
    text = ''
      Section "Device"
          Identifier "XSPICE"
          Driver "spiceqxl"
      EndSection

      Section "Files"
          ModulePath "${self.xorg.xorgserver}/lib/xorg/modules/"
          ModulePath "${self.xspice}/lib/xorg/modules/"
      EndSection

      Section "InputDevice"
          Identifier "XSPICE POINTER"
          Driver     "xspice pointer"
      EndSection

      Section "InputDevice"
          Identifier "XSPICE KEYBOARD"
          Driver     "xspice keyboard"
      EndSection

      Section "Monitor"
          Identifier    "Configured Monitor"
      EndSection

      Section "Screen"
          Identifier     "XSPICE Screen"
          Monitor        "Configured Monitor"
          Device         "XSPICE"
          DefaultDepth 24
          SubSection "Display"
                     Depth 24
                     Modes "1600x900"
          EndSubSection
      EndSection

      Section "ServerLayout"
          Identifier "XSPICE Server"
          Screen "XSPICE Screen"
          InputDevice "XSPICE KEYBOARD"
          InputDevice "XSPICE POINTER"
      EndSection

      # Prevent udev from loading vmmouse in a vm and crashing.
      Section "ServerFlags"
          Option "AutoAddDevices" "False"
          Option "NumHeads" "1"
      EndSection
    '';
  };

  # see nixpkgs/nixos/modules/services/x11/display-managers/default.nix
  xspice-session-wrapper = self.writeShellScriptBin "xspice-session-wrapper" ''
    . /etc/profile
    cd "$HOME"
    if test -e ~/.Xresources; then
        ${self.xorg.xrdb}/bin/xrdb -merge ~/.Xresources
    elif test -e ~/.Xdefaults; then
        ${self.xorg.xrdb}/bin/xrdb -merge ~/.Xdefaults
    fi
    setxkbmap -option ctrl:nocaps

    # Work around KDE errors when a user first logs in and
    # .local/share doesn't exist yet.
    mkdir -p "$HOME/.local/share"

    ${self.pekwm}/bin/pekwm &
    waitPID=$!

    if test "$1"; then
      "$@" &
      waitPID=$!
    fi
    test -n "$waitPID" && wait "$waitPID"
  '';

  xspice-server = self.writeShellScriptBin "xspice-server" ''
    export LIBGL_DRIVERS_PATH=${self.mesa_drivers}/lib/dri:${self.pkgsi686Linux.mesa_drivers}/lib/dri
    export LD_LIBRARY_PATH=${self.mesa_drivers}/lib:${self.pkgsi686Linux.mesa_drivers}/lib:$LD_LIBRARY_PATH
    export MANPATH=${self.xlibs.setxkbmap}/share/man:$MANPATH
    export PATH=${self.xlibs.setxkbmap}/bin:$PATH
    export GALLIUM_DRIVER=llvmpipe
    exec ${self.xspice}/bin/Xspice -logfile ./XSpice.log --config ${xspice-server-config} "$@"
  '';

  df-xspice-session = self.writeShellScriptBin "xspice-session" ''
    exec ${xspice-session-wrapper}/bin/xspice-session-wrapper \
      ${self.dwarf-fortress-packages.dwarf-fortress_0_47_02}/bin/dwarf-fortress
  '';

  df-server = self.writeShellScriptBin "df-server" ''
    exec ${xspice-server}/bin/xspice-server \
         --port 10000 --disable-ticketing :1.0 \
         --xsession ${df-xspice-session}/bin/xspice-session
  '';
}
