{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    fileSystems."/" = {
      device = "rpool/root";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/23FB-4900";
      fsType = "vfat";
    };

    fileSystems."/mnt/storage/media" = {
      device = "storage/media";
      fsType = "zfs";
      depends = ["/"];
    };

    fileSystems."/mnt/storage/users/coconnor" = {
      device = "storage/users/coconnor";
      fsType = "zfs";
      depends = ["/"];
    };

    fileSystems."/var/lib/postgresql" = {
      device = "rpool/postgresql";
      fsType = "zfs";
      depends = ["/"];
    };

    fileSystems."/var/lib/hass" = {
      device = "rpool/hass";
      fsType = "zfs";
      depends = ["/" "/mnt/storage/hass"];
    };

    fileSystems."/mnt/storage/hass" = {
      device = "storage/hass";
      fsType = "zfs";
      depends = ["/"];
    };

    services.zfs.autoScrub.enable = true;

    swapDevices = [];
  };
}
