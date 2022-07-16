{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "tsc=unstable" ];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/81b83e13-9b10-4f26-9268-dd90c50dddef";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/025E-C3DB";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/7ecc7515-1b48-41a4-8f83-8c8f54820e8f"; }
    ];
}
