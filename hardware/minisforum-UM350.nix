{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    nix = {
      extraOptions = ''
        build-cores = 3
      '';
      maxJobs = 2;
    };

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "tsc=unstable" ];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
