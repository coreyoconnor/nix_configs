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

  boot.kernelModules =
  [
    "vfio"
    "vfio_pci"
    "vfio_iommu_type1"
    "vfio_virqfd"
    "pci_stub"
  ];

  boot.kernelParams =
  [
    "loglevel=7"
    "nomodeset"
    "intel_iommu=on"
    # intel USB controller, intel audio, intel USB controller, nvidia GPU, nvidia audio,
    # Oxygen HD Audio, ASMedia USB controller
    # "vfio_pci.ids=8086:1d2d,8086:1d20,8086:1d26,10de:06cd,10de:0be5,13f6:8788,1b21:1042"
    # nvidia GPU, nvidia audio, Oxygen HD Audio
    "vfio_pci.ids=10de:06cd,10de:0be5,13f6:8788"
    # "vfio_iommu_type1.allow_unsafe_interrupts=1"
    # "kvm.allow_unsafe_assigned_interrupts=1"
    "kvm.emulate_invalid_guest_state=1"
    "kvm.ignore_msrs=1"
    # disable USB entirely - this is forwarded to the windows gues
    # "usbcore.nousb"
    # nevermind. use usbdevice. Qemu freezes otherwise.
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];

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
    interfaces.enp10s0 =
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

  vmhost.type = "libvirtd";

  system.stateVersion = "16.03";
}
