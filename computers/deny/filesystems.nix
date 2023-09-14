{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      supportedFilesystems = ["zfs"];

      zfs.requestEncryptionCredentials = true;
      plymouth.enable = false;
    };

    fileSystems."/" = {
      device = "rpool/root/nixos";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/TBD";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/TBD"; }
    ];

    services.zfs.autoScrub.enable = true;
  };
}
