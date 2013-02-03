{config, pkgs, ...}:

{
  require = 
  [
    ./user-coconnor.nix
    ./editorIsVim.nix
    ./java-dev.nix
    ./scala-dev.nix
    ./standard-packages.nix
    ./standard-services.nix
    ./haskell-dev.nix
    ./kde4.nix
    ./vm-host.nix
    ./wine.nix
  ];

  nix.maxJobs = 10;

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraKernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.vesa = false;

  # boot.kernelPackages = pkgs.linuxPackages_3_7;

  boot.kernelModules =
  [
    "acpi-cpufreq"
    "kvm-intel"
  ];

  boot.initrd.kernelModules = 
  [
    "ext4" 
    "usb_storage"
    "ehci_hcd"
    "uhci_hcd"
    "ata_piix"
    "firewire_ohci"
    "usbhid" 
  ];

  networking = 
  {
    hostName = "nixpad"; # Define your hostname.
    interfaceMonitor.enable = true; # Watch for plugged cable.
    # Cannot use wicd and have useDHCP true
    useDHCP = false;
    wicd.enable = true;
  };
      
	# Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;

  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # Add filesystem entries for each partition that you want to see
  # mounted at boot time.  This should include at least the root
  # filesystem.
  fileSystems =
  [ { mountPoint = "/";
      device = "/dev/disk/by-label/root";
    }
  ];

  # List swap partitions activated at boot time.
  swapDevices =
  [ { device = "/dev/disk/by-label/swap"; }
  ];

  # Select internationalisation properties.
  i18n =
  {
    consoleFont = "lat9w-16";
    consoleKeyMap = "emacs2";
    defaultLocale = "en_US.UTF-8";
  };


  # X11 config
  # starts 
  services.xserver = 
  {
    enable = true;
    autorun = true;
    videoDrivers = [ "nvidia" "vesa" ];
    exportConfiguration = true;
    layout = "us";
    synaptics =
    {
      enable = true;
      identifier = "appletouch touchpad catchall";
      twoFingerScroll = true;
      tapButtons = false;
      minSpeed = "0.5";
      maxSpeed = "1.2";
      accelFactor = "0.1";
      additionalOptions = ''
        Option "HorizHysteresis" "1"
        Option "VertHysteresis" "1"
        Option "SHMConfig" "true"
        Option "FingerHigh" "15"
        Option "FingerLow" "2"
        Option "SendCoreEvents" "true"
        Option "AccelerationProfile" "-1"
        Option "AccelerationScheme" "none"
      '';
    };
  };

  environment.x11Packages = 
  [
    pkgs.xorg.xf86inputsynaptics
  ];

  environment.shellInit = ''
      NIX_PATH=/root/nixos
      NIX_PATH=$NIX_PATH:nixpkgs=/root/nixpkgs
      NIX_PATH=$NIX_PATH:nixos=/root/nixos
      NIX_PATH=$NIX_PATH:nixos-config=/root/nix_configs/nixpad_config.nix
      NIX_PATH=$NIX_PATH:services=/etc/nixos/services
      export NIX_PATH
  '';
}

