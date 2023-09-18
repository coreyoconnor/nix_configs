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
      plymouth.enable = true;
    };

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b694aa55-35de-4d74-bbb7-0176a64e5178";
        fsType = "ext4";
      };

    boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/e5991b53-6c4a-48dd-9950-2554f25ee667";

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/8540-4477";
        fsType = "vfat";
      };

    swapDevices = [
      { device = "/swapfile"; size = 10000; }
    ];
  };
}
