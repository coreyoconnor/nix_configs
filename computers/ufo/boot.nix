{ config, lib, pkgs, ... }:

{
  config = {
    boot = {
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];

      initrd = {
        availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "igb" ];
        kernelModules = [ ];
        luks.devices = {
          # root pool
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4ADE-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4ADE-part2";
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4B17-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4B17-part2";
          "luks-rpool-nvme-CT2000P3PSSD8_2322E6DC4B24-part2".device = "/dev/disk/by-id/nvme-CT2000P3PSSD8_2322E6DC4B24-part2";
          # storage pool
          "luks-storage-ata-ST12000VN0008-2YS101_ZRT17FRW-part1".device = "/dev/disk/by-id/ata-ST12000VN0008-2YS101_ZRT17FRW-part1";
          "luks-storage-ata-ST12000VN0008-2YS101_ZRT17HLL-part1".device = "/dev/disk/by-id/ata-ST12000VN0008-2YS101_ZRT17HLL-part1";
          "luks-storage-ata-ST12000VN0008-2YS101_ZRT17HN7-part1".device = "/dev/disk/by-id/ata-ST12000VN0008-2YS101_ZRT17HN7-part1";
        };
        network = {
          enable = true;

          ssh = {
            enable = true;
            authorizedKeys = [ (builtins.readFile ../../domains/primary/users/ssh/coconnor.pub) ];
            hostKeys = [
              "/etc/secrets/initrd/ssh_host_ed25519_key"
            ];
            port = 2269;
          };
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

