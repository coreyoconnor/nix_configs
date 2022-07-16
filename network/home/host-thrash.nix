{ config, lib, pkgs, ... }:
with lib;
let
  localIPv4 = "192.168.86.5";
  localIPv6 = "2601:602:9700:f0fc::5";
in {
  imports = [ ./default.nix ];

  config = {
    networking = {
      hostName = "thrash";
      interfaces = {
        eno1 = {
          ipv4.addresses = [{
            address = localIPv4;
            prefixLength = 24;
          }];
          ipv6 = {
            addresses = [{
              address = localIPv6;
              prefixLength = 64;
            }];
          };
          useDHCP = true;
        };

        enp2s0.useDHCP = true;
        wlp4s0.useDHCP = true;
      };

      wireless.enable = true;
    };
  };
}
