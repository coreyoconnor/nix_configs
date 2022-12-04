{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    nix = {
      settings = {
        cores = 3;
        max-jobs = 2;
      };
    };

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "tsc=unstable" ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
