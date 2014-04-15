{config, pkgs, ...}:
{
  require = 
  [
    ../../users/coconnor.nix
    ../../editorIsVim.nix
    ../../filesystem.nix
    ../../java-dev.nix
    ../../jenkins-master.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../kde4.nix
    ../../vm-host.nix
    ../../proprietary_nvidia_drivers.nix
  ];

  environment.computerName = "toast";

  nix.maxJobs = 10;
  
  boot.kernelModules = [ "acpi-cpufreq" "kvm-amd" "vhost_net" ];
  boot.kernelPackages = pkgs.linuxPackages_3_12;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

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
    extraHosts = ''
    127.0.0.1 toast
    192.168.1.95 ufo
    '';
    firewall.allowedTCPPorts = [ 8080 9091 ];
  };
  
  fileSystems =
  [ 
    { mountPoint = "/home/";
      device = "/dev/disk/by-label/home";
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
      options = "guest,sec=ntlm";
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
    # windowManager.xmonad.enable = true;
    # windowManager.xmonad.enableContribAndExtras = true;
    # windowManager.default = "xmonad";
    # desktopManager.default = "none";
    desktopManager.kde4.enable = true;
    layout = "us";
    # https://bbs.archlinux.org/viewtopic.php?id=117102
    deviceSection = ''
    Option "UseEvents" "false"
    '';
  };

  hardware.opengl.videoDrivers = [ "nvidia" "vesa" ];

  systemd.services.cgminer = {
    serviceConfig = {
      Nice = 19;
      IOSchedulingClass = "idle";
    };
  };

  system.activationScripts =
  {
    removeGlobalAsoundConf = ''
      rm -f /etc/asound.conf
    '';
  };

  services.cgminer =
  {
    enable = true;
    pools = 
    [
      {
        url = "stratum+tcp://stratum.mining.eligius.st:3334";
        user = "1M5DoWSWRtGCNuJfwdC8294zRx1eK7FSGY";
        pass = "";
      }
    ];
    config =
    {
      auto-fan = true;
      auto-gpu = false;
      device = "1";
    };
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];
}

