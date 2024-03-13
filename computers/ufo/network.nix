{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  localIPv4_1 = "192.168.86.6";
  localIPv6_1 = "2601:602:9700:f0fc::6";
in {
  imports = [
    ../../network/home
  ];
  config = {
    networking = {
      hostId = "abab4ab2";
      hostName = "ufo";
      useDHCP = true;

      interfaces = {
        eno1 = {
          useDHCP = true;
        };
      };
    };
  };
}
