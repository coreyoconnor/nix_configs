{config, pkgs, ...}:

{
  require = 
  [
    ./user-coconnor.nix
    ./editorIsVim.nix
    ./java-dev.nix
    ./scala-dev.nix
    ./standard-env.nix
    ./standard-packages.nix
    ./standard-services.nix
    ./haskell-dev.nix
    ./kde4.nix
    ./vm-host.nix
  ];

  nix.maxJobs = 10;
  
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraKernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.kernelModules = [ "acpi-cpufreq" "kvm-amd" ];
  boot.vesa = false;

  boot.initrd.kernelModules = 
  [
    "ext4" 
    "ata_piix"
    "mptspi"
    "ehci_hcd"
    "pata_amd"
    "ahci"
    "usb_storage"
    "usbhid"
  ];

  boot.loader.grub = 
  {
    # Use grub 2 as boot loader.
    enable = true;
    version = 2;

    device = "/dev/sda";

    extraEntries = ''
    menuentry "Win" {
        insmod ntfs
        set root='(hd1,1)'
        chainloader +1
    }
    '';
  };

  boot.resumeDevice = "8:2";

  networking = 
  {
    hostName = "toast"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
    extraHosts = ''
    127.0.0.1 toast
    '';
  };
  
  fileSystems =
  [ 
    { mountPoint = "/";
      device = "/dev/disk/by-label/root";
    }
    { mountPoint = "/home/";
      device = "/dev/sda4";
    }
  ];

  swapDevices =
  [ 
    { device = "/dev/disk/by-label/swap"; }
  ];

  # Select internationalisation properties.
  i18n = 
  {
    consoleFont = "lat9w-16";
    consoleKeyMap = "emacs2";
    defaultLocale = "en_US.UTF-8";
  };

  services.transmission =
  {
    enable = true;
  };

  # X11 config
  # starts 
  services.xserver = 
  {
    enable = true;
    autorun = true;
    exportConfiguration = true;
    videoDrivers = [ "nvidia" "vesa" ];
    layout = "us";
    # https://bbs.archlinux.org/viewtopic.php?id=117102
    deviceSection = ''
    Option "UseEvents" "false"
    '';
  };

  services.xserver.desktopManager.e17.enable = true;

  environment.shellInit = ''
      NIX_PATH=/etc/nixos/nixos
      NIX_PATH=$NIX_PATH:nixpkgs=/etc/nixos/nixpkgs
      NIX_PATH=$NIX_PATH:nixos=/etc/nixos/nixos
      NIX_PATH=$NIX_PATH:nixos-config=/etc/nixos/configuration.nix
      NIX_PATH=$NIX_PATH:services=/etc/nixos/services
      export NIX_PATH
  '';

  # tests = [];
}

