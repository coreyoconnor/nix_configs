{ config, lib, pkgs, ... }:

{
  config = {
    fileSystems."/" =
      { device = "rpool/root";
        fsType = "zfs";
      };

    fileSystems."/home" =
      { device = "rpool/home";
        fsType = "zfs";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/23FB-4900";
        fsType = "vfat";
      };

    fileSystems."/mnt/storage/media" =
      { device = "storage/media";
        fsType = "zfs";
        depends = ["/"];
      };

    fileSystems."/mnt/storage/users/coconnor" =
      { device = "storage/users/coconnor";
        fsType = "zfs";
        depends = ["/"];
      };

    fileSystems."/mnt/storage/postgresql" =
      { device = "storage/postgresql";
        fsType = "zfs";
        depends = ["/"];
      };

    fileSystems."/mnt/storage/hass" =
      { device = "storage/hass";
        fsType = "zfs";
        depends = ["/"];
      };

    fileSystems."/mnt/storage-old" = {
      fsType = "cifs";
      device = "//agh/storage";
      options = [
        "guest"
        "uid=media"
        "gid=users"
        "rw"
        "setuids"
        "file_mode=0664"
        "dir_mode=0775"
        "vers=3.0"
        "nofail"
        "x-systemd.automount"
        "noauto"
      ];
    };

    services.zfs.autoScrub.enable = true;

    swapDevices = [ ];
  };
}
