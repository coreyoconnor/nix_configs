{ config, pkgs, ... }:
with pkgs.lib; {
  users.extraUsers = {
    nix = {
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [ ./ssh/nix.pub ];
    };
  };
}
