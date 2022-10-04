{ config, pkgs, ... }:
with pkgs.lib; {
  users.groups = {
    monkey = {
    };
  };

  users.users = {
    monkey = {
      isSystemUser = true;

      createHome = true;
      home = "/home/monkey";
      shell = pkgs.bashInteractive + "/bin/bash";

      group = "monkey";
      extraGroups = [ "libvirtd" "docker" ];
      subUidRanges = [
        { startUid = 300000; count = 65536; }
      ];
      subGidRanges = [
        { startGid = 300000; count = 65536; }
      ];

      openssh.authorizedKeys.keyFiles = [ ./ssh/coconnor.pub ];
    };
  };
}
