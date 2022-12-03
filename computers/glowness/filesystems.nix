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
    };

    fileSystems."/" = {
      device = "rpool/root/glowness-1";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/home-1";
      fsType = "zfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/???";
      fsType = "ext4";
    };

    services.zfs.autoScrub.enable = true;

    virtualisation.docker.storageDriver = "zfs";
  };
}
