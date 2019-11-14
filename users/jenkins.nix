{ config, pkgs, ... }:
with pkgs.lib; {
  users.extraUsers.jenkins = {
    openssh.authorizedKeys.keyFiles = [ ./ssh/jenkins.pub ];
    extraGroups = [ "docker" "libvirtd" "wheel" ];
  };
}
