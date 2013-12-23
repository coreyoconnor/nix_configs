{config, pkgs, ...}:

{
  require = 
  [
    ./user-coconnor.nix
    ./editorIsVim.nix
    ./filesystem.nix
    ./java-dev.nix
    ./scala-dev.nix
    ./standard-env.nix
    ./standard-packages.nix
    ./standard-services.nix
    ./haskell-dev.nix
    ./i18n.nix
    ./kde4.nix
    ./vm-host.nix
    ./proprietary_nvidia_drivers.nix
  ];

  nix.maxJobs = 10;
  
  boot.kernelModules = [ "acpi-cpufreq" "kvm-amd" "vhost_net" ];

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
    { mountPoint = "/home/";
      device = "/dev/sda4";
    }
  ];

  services.transmission =
  {
    enable = true;
    settings =
    {
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      umask = 2;
      download-dir = "/mnt/nomnom/media/Downloads";
    };
  };

  systemd.mounts =
  [
    {
      what = "//192.168.1.10/media";
      where = "/mnt/nomnom/media";
      type = "cifs";
      options = "guest";
      requiredBy = ["transmission.service"];
    }
  ];

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

  services.cgminer =
  {
    enable = true;
    pools = 
    [
      {
        url = "stratum+tcp://stratum.mining.eligius.st:3334";
        user = "17n5XxYfR8ucy9dc2ycVVSymrcwB9tCVo4";
        pass = "";
      }
    ];
    config =
    {
      auto-fan = true;
      auto-gpu = true;
    };
  };

  services.xserver.desktopManager.e17.enable = true;

  environment.shellInit = ''
      NIX_PATH=nixos=/etc/nixos/nixpkgs/nixos
      NIX_PATH=$NIX_PATH:nixos-config=/etc/nixos/configuration.nix
      NIX_PATH=$NIX_PATH:services=/etc/nixos/services
      NIX_PATH=$NIX_PATH:nixpkgs=/etc/nixos/nixpkgs
      export NIX_PATH
  '';

  # /home/coconnor needs o+x
  #services.nginx =
  #{
  #  enable = true;
  #  httpSectionContent = ''
  #    include    ${pkgs.nginx}/conf/mime.types;
  #    default_type application/octet-stream;
#
#      server {
#        server_name toast;
#
#        root /;
#      }
#    '';
#  };

  # tests = [];
}

