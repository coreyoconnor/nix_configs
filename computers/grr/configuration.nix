{ config, pkgs, ... }:

{
  require =
  [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../java-dev.nix
    ../../jenkins-node.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../vm-host.nix
    # ./windows-desktop-vm.nix
    ../../desktop.nix
  ];

  vmhost =
  {
    type = "libvirtd";
  };

  # grub bootloader installed to all devices in the boot raid1 array
  boot =
  {
    loader.grub =
    {
      enable = true;
      version = 2;
      devices =
      [
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055024"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055124"
      ];
      zfsSupport = true;
    };

    kernelParams = [ "kvm-intel.nested=1" ];
    kernelPackages = pkgs.linuxPackages_4_14;
  };

  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_14;
    };
    nixpkgs.config.permittedInsecurePackages = ["linux-4.13.16"];
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr";
    useDHCP = false;
    bridges.br0.interfaces = [ "enp9s0" ];
    interfaces.br0 =
    {
      ipAddress = "192.168.1.7";
      prefixLength = 24;
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.openssh.extraConfig = ''
    UseDNS no
  '';

  services.journald.console = "/dev/tty12";

  system.stateVersion = "16.03";

  boot.kernel.sysctl =
  {
    "vm.nr_hugepages" = 16384;
  };

  networking.firewall =
  {
    allowedTCPPorts = [ 10000 ];
  };

  systemd.services.update-freemyip =
  {
    description = "Updates FreeMyIP";

    path = [ pkgs.curl ];

    serviceConfig =
    {
      Type = "oneshot";
      User = "nobody";
    };
    script = ''
      set -ex
      curl https://freemyip.com/update?token=588f227086d6557b1589553c&domain=grr.freemyip.com
    '';
  };

  systemd.timers.update-freemyip =
  {
    wantedBy = [ "timers.target" ];
    timerConfig =
    {
      OnCalendar = "*:0/30";
      Persistent = "yes";
    };
  };

  hardware =
  {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    opengl =
    {
      enable = true;
      driSupport32Bit = true;
    };
  };
  services.xserver =
  {
    desktopManager =
    {
      default = "plasma5";
      plasma5.enable = true;
    };
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      BusID "PCI:05:00:00"
    '';
    xrandrHeads =
    [
      {
        output = "DVI-I-1-1";
        monitorConfig = ''
          Option "PreferredMode" "2560x1080"
        '';
        primary = true;
      }
    ];
  };
  hardware.pulseaudio =
  {
    enable = true;
    support32Bit = true;
  };
  services.kbfs =
  {
    enable = true;
  };
}
