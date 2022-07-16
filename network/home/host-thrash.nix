{ config, lib, pkgs, ... }:
with lib;
let
  localIp = "192.168.86.5";
in {
  imports = [
    ./hosts.nix
  ];

  config = {
    networking = {
      hostName = "thrash";
      defaultGateway = "192.168.86.1";
      nameservers = [ "192.168.86.2" "1.1.1.1" ];
      interfaces = {
        eno1 = {
          ipv4.addresses = [{
            address = localIp;
            prefixLength = 24;
          }];
          ipv6 = {
            addresses = [{
              address = "2601:602:9700:f0fc::5";
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
