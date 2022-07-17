{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    fileSystems."/" =
      { device = "/dev/disk/by-uuid/81b83e13-9b10-4f26-9268-dd90c50dddef";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/025E-C3DB";
        fsType = "vfat";
      };

    swapDevices = [
      { device = "/dev/disk/by-uuid/7ecc7515-1b48-41a4-8f83-8c8f54820e8f"; }
    ];
  };
}
