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

  environment.systemPackages =
  [
    pkgs.stdenv
    pkgs.autoconf
    pkgs.automake
    pkgs.bashInteractive
    pkgs.glibcLocales
    pkgs.screen
    pkgs.utillinuxCurses
    pkgs.gitSVN
    pkgs.acpi
    pkgs.pulseaudio
    pkgs.gcc
    pkgs.gettext
    pkgs.glib
    pkgs.gnumake
    pkgs.nginx
    pkgs.qemu
    pkgs.kvm
  ];

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
  services.udisks.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;
  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
  services.openssh.enable = true;
  # TODO: I only want to disable X11 forwarding for ssh client
  services.openssh.forwardX11 = false;
  services.virtualbox.enable = true;
}

