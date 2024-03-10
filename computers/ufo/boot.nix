{ config, lib, pkgs, ... }:

{
  config = {
    boot = {
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        kernelModules = [ ];
        luks.devices = {
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4ADE-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4ADE-part2";
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4B17-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4B17-part2";
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4B24-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4B24-part2";
        };
      };

      loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };
}

