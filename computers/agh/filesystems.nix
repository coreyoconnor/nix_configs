{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    environment.systemPackages = [ pkgs.btrfs-progs ];

    fileSystems = {
      "/" = {
        device = "/dev/sda2";
        fsType = "ext4";
      };

      non-admin-home = {
        mountPoint = "/mnt/non-admin-home";
        device = "/dev/disk/by-label/home";
      };

      storage = {
        mountPoint = "/mnt/storage";
        device = "/dev/disk/by-label/storage";
      };
    };

    system.activationScripts.non-admin-home = ''
      [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
      mkdir -p /workspace/coconnor
      chown coconnor:users /workspace/coconnor
    '';

    boot.loader.grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
    };
  };
}
