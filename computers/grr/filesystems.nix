{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      loader.grub = {
        enable = true;

        # grub bootloader installed to all devices in the boot raid1 array
        devices = [
          "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
          "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
          "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
          "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
          "/dev/disk/by-id/ata-ADATA_SP550_2G3220055024"
          "/dev/disk/by-id/ata-ADATA_SP550_2G3220055124"
        ];
        zfsSupport = true;
        version = 2;
      };
    };

    fileSystems."/" = {
      device = "rpool/root/grr-1";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/bea4ca24-f511-45eb-b979-3d9d7137079e";
      fsType = "ext4";
    };

    fileSystems."/mnt/storage/validator" = {
      device = "rpool/validator";
      fsType = "zfs";
      depends = [ "/" ];
    };

    services.zfs.autoScrub.enable = true;

    virtualisation.docker.storageDriver = "zfs";
  };
}
