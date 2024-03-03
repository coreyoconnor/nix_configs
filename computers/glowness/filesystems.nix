{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../network/home/resource-media-share.nix
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
      device = "/dev/disk/by-uuid/EEB1-125F";
      fsType = "vfat";
    };

    fileSystems."/mnt/42b483bc-d29d-43b9-bc1c-203c73f792dd" = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_980_1TB_S64ANG0R507415R";
      fsType = "ext4";
      depends = ["/"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/fb7a013f-6c4c-4962-a95a-22f49c0f36a6";}
    ];

    services.zfs.autoScrub.enable = true;
  };
}
