# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  require =
  [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../users/coconnor.nix
    ../../users/admin.nix
    ../../vm-host.nix
  ];

  vmhost =
  {
    type = "libvirtd";
    vfio =
    {
      enable = true;
      iommu = "intel";
      nvidiaBinds = [ "10de:17c8" "10de:0fb0" ];
      forceBinds = [ "0000:08:00.0" ];
      bootBinds = [ "13f6:8788" ];
    };
  };

  # grub bootloader installed to all devices in the boot raid1 array
  boot.loader.grub =
  {
    enable = true;
    version = 2;
    devices =
    [
      "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
      "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
      "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
      "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
    ];
    zfsSupport = true;
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr"; # must be unique
    useDHCP = false;
    interfaces.enp9s0 =
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

  services.xserver =
  {
    enable = true;
    autorun = false;
  };

  services.journald.console = "/dev/tty12";

  system.stateVersion = "16.03";
}
