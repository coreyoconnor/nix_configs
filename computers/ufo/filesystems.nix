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

    swapDevices = [ ];
  };
}
