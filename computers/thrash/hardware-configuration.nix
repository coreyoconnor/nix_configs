{ config, lib, pkgs, ... }:

{
  imports =
  [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7f88268b-ead9-49b7-9e72-21b4df8ffa91"; }
    ];
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    options = [ "rw" "data=ordered" "relatime" ];
    fsType = "ext4";
};

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  i18n.consoleFont = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
