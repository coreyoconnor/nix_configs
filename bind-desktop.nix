{config, pkgs, ...}:

{
  imports =
  [ <nixos/modules/installer/scan/not-detected.nix>
  ];

  nix.maxJobs = 2;

  boot.extraModulePackages = [ ];
  boot.kernelModules = [ ];

  boot.loader.grub = 
  {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_hcd" "ehci_hcd" ];

  boot.loader.grub = 
  {
    # Use grub 2 as boot loader.
    enable = true;
    version = 2;

    # Define on which hard drive you want to install Grub.
    device = "/dev/sda";
  };

  fileSystems."/" =
  { device = "/dev/sda2";
    fsType = "ext4";
    options = "rw,data=ordered,relatime";
  };

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  networking = 
  {
    hostName = "nix-dev"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
  };
  
  security.sudo.enable = true;
  security.sudo.configFile = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS

      root        ALL=(ALL) SETENV: ALL
      %wheel      ALL=(ALL) NOPASSWD: SETENV: ALL
'';

  services.dbus.enable = true;
  services.hal.enable = true;
  services.udisks.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;
  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
  services.openssh.enable = true;
  # TODO: I only want to disable X11 forwarding for ssh client
  services.openssh.forwardX11 = false;
  services.virtualbox.enable = true;
  services.xserver = 
  {
    enable = true;
    autorun = true;
    # useXFS = "unix/:7100";
    videoDrivers = [ "virtualbox" "vesa" ];

    displayManager.slim.defaultUser = "coconnor";

    desktopManager = 
    {
      session = 
      [ 
        {
          name = "bind-desktop";
          start = ''
              xcompmgr -n &
              ${pkgs.linuxPackages.virtualboxGuestAdditions}/bin/VBoxClient-all
              xrdb -merge $HOME/.app-defaults/*

              # Set GTK_PATH so that GTK+ can find the Xfce theme engine.
              export GTK_PATH=${pkgs.xfce.gtk_xfce_engine}/lib/gtk-2.0

              # Set GTK_DATA_PREFIX so that GTK+ can find the Xfce themes.
              export GTK_DATA_PREFIX=${config.system.path}

              # Necessary to get xfce4-mixer to find GST's ALSA plugin.
              # Ugly.
              export GST_PLUGIN_PATH=${config.system.path}/lib

              xfce4-session
          '';
          bgSupport = false;
        } 
      ];
    };

    windowManager =
    {
      default = "xmonad";
      xmonad.enable = true;
    };

    desktopManager.default = "bind-desktop";

    exportConfiguration = true;

    serverLayoutSection = ''
        InputDevice "VBoxMouse" "CorePointer"
    '';

    config = ''
        Section "InputDevice"
            Identifier "VBoxMouse"
            Driver "vboxmouse"
        EndSection
    '';
  };

  services.dbus.packages =
  [
    pkgs.gnome.GConf
  ];

  environment.x11Packages = 
  [
      # pkgs.abiword
      pkgs.chrome
      pkgs.desktop_file_utils
      pkgs.eclipses.eclipse_sdk_37
      pkgs.evince
      pkgs.firefox
      pkgs.flashplayer
      pkgs.gnome.GConf
      pkgs.gnome.gtk
      pkgs.gnome.intltool
      pkgs.gnome.gtk_doc
      pkgs.gnome.gnomeicontheme
      pkgs.gnome.pango
      pkgs.gnome.vte
      pkgs.gtkLibs.gtk # To get GTK+'s themes.
      pkgs.kde4.calligra
      pkgs.kde4.kdelibs
      pkgs.kde4.kde_runtime
      pkgs.kde4.oxygen_icons
      pkgs.linuxPackages.virtualboxGuestAdditions
      pkgs.shared_mime_info
      pkgs.shared_desktop_ontologies
      # pkgs.swt
      pkgs.xfce.exo
      pkgs.xfce.gtk_xfce_engine
      pkgs.xfce.libxfcegui4 # For the icons.
      pkgs.xfce.libxfce4ui
      pkgs.xfce.ristretto
      pkgs.xfce.terminal
      pkgs.xfce.xfce4icontheme
      pkgs.xfce.xfce4session
      pkgs.xfce.xfce4panel
      pkgs.xfce.xfce4settings
      pkgs.xfce.xfce4mixer
      pkgs.xfce.xfceutils
      pkgs.xfce.xfconf
      pkgs.xfce.xfdesktop
      pkgs.xfce.garcon
      pkgs.xfce.thunar
      pkgs.xfce.thunar_volman
      pkgs.xfce.gvfs
      pkgs.xfce.xfce4_appfinder
      pkgs.xcompmgr
      pkgs.xlibs.fontutil
      pkgs.xlibs.kbproto
      pkgs.xlibs.libICE
      pkgs.xlibs.libXt
      pkgs.xlibs.libXtst
      pkgs.xlibs.libXaw
      pkgs.xlibs.xproto
      pkgs.xlibs.xinput

      pkgs.fontconfig
      pkgs.hicolor_icon_theme
      pkgs.xclip
      pkgs.xdg_utils
      pkgs.rxvt_unicode
  ];

  environment.pathsToLink =
  [ 
      "/share"
      "/etc/gconf"
  ];

  environment.shellInit = ''
      export GIO_EXTRA_MODULES=${pkgs.xfce.gvfs}/lib/gio/modules
      export JAVA_HOME=${pkgs.jdk}
  '';

  services.syslogd.extraConfig = ''
      user.* /var/log/user
  '';

  services.xfs.enable = false;
  fonts =
  {
      enableFontDir = true;
      extraFonts = 
      [
          pkgs.andagii
          pkgs.anonymousPro
          pkgs.arkpandora_ttf
          pkgs.bakoma_ttf
          pkgs.corefonts
          pkgs.cm_unicode
          pkgs.junicode
          pkgs.ucsFonts
          pkgs.unifont
          pkgs.vistafonts
      ];
  };

  environment.systemPackages =
  [
      pkgs.stdenv
      pkgs.atk
      pkgs.ant
      pkgs.autoconf
      pkgs.automake
      pkgs.bashInteractive
      pkgs.cairo
      pkgs.gdb
      pkgs.gdk_pixbuf
      pkgs.glibcLocales
      pkgs.screen
      pkgs.utillinuxCurses
      pkgs.gitSVN
      pkgs.acpi
      pkgs.pulseaudio
      pkgs.ruby19
      pkgs.rubySqlite3
      pkgs.gcc
      pkgs.coq
      pkgs.oprofile
      pkgs.ffmpeg
      pkgs.freetype
      pkgs.fuse
      pkgs.gettext
      pkgs.glib
      pkgs.gnumake
      pkgs.linuxPackages.virtualbox
      pkgs.inconsolata
      pkgs.isabelle
      pkgs.maven3
      pkgs.jdk
      pkgs.jre
      pkgs.nginx
      pkgs.ocaml
      pkgs.perlXMLParser
      pkgs.python
      pkgs.emacs23
      pkgs.qemu
      pkgs.vala
      pkgs.kvm
      pkgs.vpnc
      pkgs.xterm
  ];


}

