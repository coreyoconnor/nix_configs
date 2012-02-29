{config, pkgs, ...}:

{
    require = 
    [
        # Include the configuration for part of your system which have been
        # detected automatically.

        ./hardware-configuration.nix
        ./editorIsVim.nix
        ./haskellIsAll.nix
    ];

    boot.initrd.kernelModules = 
    [
        # Specify all kernel modules that are necessary for mounting the root
        # file system.
        #
        "ext4" "ata_piix"
    ];

    boot.loader.grub = 
    {
        # Use grub 2 as boot loader.
        enable = true;
        version = 2;

        # Define on which hard drive you want to install Grub.
        device = "/dev/sda";
    };

    # I need to disable IPv6 because VirtualBox appears to have an issue with DHCP and IPv6. I have
    # not traced down exactly what is up. I just observed disabling IPv6 avoids problems.
    # XXX not anymore?
    networking = 
    {
        hostName = "dev"; # Define your hostname.
        interfaceMonitor.enable = true; # Watch for plugged cable.
        # enableIPv6 = false;
    };

    # Also required to disable ipv6
    # boot.extraKernelParams = [ "ipv6.disable=1" ];

    fileSystems = 
    [
        # root file system
        { 
            mountPoint = "/";
            # XXX: Use labels
            device = "/dev/sda2";
        }
    ];

    swapDevices = 
    [
        # swap
        { device = "/dev/sda1"; }
    ];

    # Select internationalisation properties.
    i18n = 
    {
        consoleFont = "lat9w-16";
        consoleKeyMap = "us";
        defaultLocale = "en_US.UTF-8";
    };

    services.dbus.enable = true;
    services.hal.enable = true;
    services.udisks.enable = true;
    services.upower.enable = true;
    services.acpid.enable = true;

    # Add an OpenSSH daemon.
    services.openssh.enable = true;

    # XXX: Disables both X11 forwarding for the client as well as server.
    # I only want to disable X11 forwarding for ssh client
    services.openssh.forwardX11 = false;

    # Add the NixOS Manual on virtual console 8
    services.nixosManual.showManual = true;

    users.extraUsers =
    { 
        corey = 
        { 
            createHome = true;
            group = "users";
            extraGroups = [ "wheel" ];
            home = "/home/corey";
            shell = pkgs.bashInteractive + "/bin/bash";
        };
    };

    # X11 config
    # starts 
    services.xserver = 
    {
        enable = true;
        autorun = true;
        # useXFS = "unix/:7100";
        videoDrivers = [ "virtualbox" "vesa" ];

        displayManager.slim.defaultUser = "corey";

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

    environment.x11Packages = 
    [
        pkgs.abiword
        pkgs.chrome
        pkgs.desktop_file_utils
        pkgs.evince
        pkgs.firefox
        pkgs.flashplayer
        pkgs.gnome.gtk
        pkgs.gnome.intltool
        pkgs.gnome.GConf
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
        pkgs.swt
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
        # stuff for redcar
        pkgs.nspr
        pkgs.xulrunner
        pkgs.rxvt_unicode
    ];

    environment.pathsToLink =
    [ 
        "/share"
    ];

    environment.shellInit = ''
        export GIO_EXTRA_MODULES=${pkgs.xfce.gvfs}/lib/gio/modules
    '';

    services.xfs.enable = false;
    fonts.enableFontDir = true;

    environment.systemPackages =
    [
        pkgs.atk
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
        pkgs.jruby165
        pkgs.ruby19
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
        pkgs.emacs23Packages.proofgeneral
        pkgs.qemu
        pkgs.vala
        pkgs.kvm
        pkgs.xterm
    ];

    time.timeZone = "America/Los_Angeles";

    security.sudo.enable = true;
    security.sudo.configFile = ''
        Defaults env_keep += "LOCALE_ARCHIVE"
        root        ALL=(ALL)           ALL
        %wheel      ALL=(ALL) NOPASSWD: ALL
'';

    services.virtualbox.enable = true;
}

