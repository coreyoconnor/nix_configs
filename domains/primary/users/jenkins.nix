{ config, pkgs, ... }:
with pkgs.lib; {
  users.users.jenkins = {
    isSystemUser = true;
    openssh.authorizedKeys.keyFiles = [ ./ssh/jenkins.pub ];
    group = "jenkins";
    extraGroups = [ "docker" "libvirtd" "wheel" ];
    subUidRanges = [
      { startUid = 200000; count = 65536; }
    ];
    subGidRanges = [
      { startGid = 200000; count = 65536; }
    ];
  };
}
