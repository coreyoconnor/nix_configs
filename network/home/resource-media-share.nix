{ config, lib, pkgs, ... }:
with lib; {
  fileSystems = {
    "/mnt/storage/media" = {
      fsType = "cifs";
      device = "//agh/media";
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
  };
}
