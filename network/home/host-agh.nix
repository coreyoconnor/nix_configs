{ config, lib, pkgs, ... }:
with lib;
let
  localIPv4 = "192.168.86.2";
  localIPv6 = "2601:602:9700:f0fc::2";
in {
  imports = [ ./default.nix ];

  config = {
    networking = {
      defaultGateway.interface = "enp1s0";

      interfaces = {
        enp1s0 = {
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

          useDHCP = false;
        };
      };

      firewall = {
        allowedTCPPorts = [ 53 445 4999 18080 27036 27037 ];
        allowedUDPPorts = [ 53 27031 27036 ];
      };

      #localCommands = ''
      #  ${pkgs.iproute}/bin/ip route add local 192.168.100.0/24 dev lo
      #'';
    };
  };
}
