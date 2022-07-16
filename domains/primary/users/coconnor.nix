{ config, pkgs, ... }:
with pkgs.lib; {
  # make sure the required groups exist
  users.groups.plugdev = {
    gid = 10001;
  };

  users.users = {
    coconnor = {
      isNormalUser = true;
      createHome = false;
      uid = 1100;
      group = "users";
      extraGroups = [
        "wheel"
        "vboxusers"
        "libvirtd"
        "jupyter"
        "transmission"
        "plugdev"
        "audio"
        "video"
        "systemd-journal"
        "docker"
        "dialout"
      ];
      home = "/home/coconnor";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [ ./ssh/coconnor.pub ];
      subUidRanges = [
        { startUid = 100000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 100000; count = 65536; }
      ];
    };
  };
}
