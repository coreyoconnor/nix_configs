{ config, pkgs, ... }:
with pkgs.lib; {
  users.users.jenkins = {
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = [ ./ssh/jenkins.pub ];
    extraGroups = [ "docker" "libvirtd" "wheel" ];
    subUidRanges = [
      { startUid = 100000; count = 65536; }
    ];
    subGidRanges = [
      { startGid = 100000; count = 65536; }
    ];
  };
}
