{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../network/home
    ../../network/home/resource-media-server.nix
  ];
  config = {
    networking = {
      hostId = "abab4ab2";
      hostName = "ufo";
      useDHCP = true;
    };
    services.avahi = {
      denyInterfaces = [ "eno1" "eno2" ];
    };
    services.resolved.enable = true;
  };
}
