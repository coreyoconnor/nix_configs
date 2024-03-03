{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  nix = {
    settings = {
      cores = 3;
      max-jobs = 2;
    };
  };

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-amd"];
    kernelParams = ["tsc=unstable"];

    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
}
