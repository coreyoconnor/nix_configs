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
      device = "rpool/root/nixos";
      fsType = "zfs";
    };

    fileSystems."/home" = {
      device = "rpool/home";
      fsType = "zfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/EEB1-125F";
      fsType = "vfat";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/fb7a013f-6c4c-4962-a95a-22f49c0f36a6"; }
    ];

    services.zfs.autoScrub.enable = true;

    virtualisation.docker.storageDriver = "zfs";
  };
}
