# Edit this configuration file which defines what would be installed on the
# system.  To Help while choosing option value, you can watch at the manual
# page of configuration.nix or at the last chapter of the manual available
# on the virtual console 8 (Alt+F8).

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
    networking = 
    {
        hostName = "dev"; # Define your hostname.
        interfaceMonitor.enable = true; # Watch for plugged cable.
        enableIPv6 = false;
    };

    # Also required to disable ipv6
    boot.extraKernelParams = [ "ipv6.disable=1" ];

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
    services.acpid.enable = true;

    # Add an OpenSSH daemon.
    services.openssh.enable = true;

    # XXX: Both disables X11 forwarding for the client as well as server.
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
        videoDrivers = [ "virtualbox" "vesa" ];

        displayManager.slim.defaultUser = "corey";

        desktopManager = 
        {
            session = 
            [ 
                {
                    name = "bind-desktop";
                    start = ''
                        ${pkgs.linuxPackages.virtualboxGuestAdditions}/bin/VBoxClient-all
                        xrdb -merge $HOME/.app-defaults/*
                        xfsettingsd
                        xterm +sb -class xmonad_TopTerm -e top &
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
        pkgs.linuxPackages.virtualboxGuestAdditions
        pkgs.xfce.thunar
        pkgs.gnome.gtk
        pkgs.gnome.gtk_doc
        pkgs.xfce.xfce4icontheme
        pkgs.xfce.xfce4session
        pkgs.xfce.xfdesktop
        pkgs.xfce.gtk_xfce_engine
        pkgs.xfce.xfce4settings
        pkgs.xterm
        pkgs.xcompmgr
        pkgs.chrome
        pkgs.firefox
        pkgs.flashplayer
        pkgs.xlibs.fontutil
        pkgs.fontconfig
        pkgs.hicolor_icon_theme
        pkgs.evince
        pkgs.xclip
    ];

    services.xfs.enable = true;
    fonts.enableFontDir = true;

    environment.systemPackages =
    [
        pkgs.bashInteractive
        pkgs.glibcLocales
        pkgs.screen
        pkgs.utillinuxCurses
        pkgs.gitSVN
        pkgs.acpi
        pkgs.pulseaudio
        pkgs.ruby19
        pkgs.gcc
        pkgs.coq
        pkgs.oprofile
        pkgs.ffmpeg
        pkgs.freetype
        pkgs.fuse
        pkgs.gimp
        pkgs.inconsolata
        pkgs.isabelle
        pkgs.jdk
        pkgs.jre
        pkgs.nginx
        pkgs.octave
        pkgs.ocaml
        pkgs.emacs23
        pkgs.emacs23Packages.proofgeneral
        pkgs.qemu
        pkgs.kvm
        pkgs.linuxPackages.systemtap
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

