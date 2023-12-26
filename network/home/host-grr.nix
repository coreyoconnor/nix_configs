{ config, lib, pkgs, ... }:
with lib;
let
  localIPv4_0 = "192.168.86.17";
  localIPv6_0 = "2601:602:9700:f0fc::17";
  localIPv4_1 = "192.168.86.7";
  localIPv6_1 = "2601:602:9700:f0fc::7";
in {
  imports = [ ./default.nix ];

  config = {
    # in case of weirdness...
    # systemd.services."systemd-networkd-wait-online".enable = false;

    networking = {
      defaultGateway.interface = "enp14s0";

      hostId = "cb4bcdd2";

      useNetworkd = true;

      interfaces = {
        #enp10s0 = {
        #  ipv4.addresses = [{
        #    address = localIPv4_0;
        #    prefixLength = 24;
        #  }];
        #  ipv6 = {
        #    addresses = [{
        #      address = localIPv6_0;
        #      prefixLength = 64;
        #    }];
        #  };
#
#          useDHCP = false;
#        };

        enp14s0 = {
          ipv4.addresses = [{
            address = localIPv4_1;
            prefixLength = 24;
          }];
          ipv6 = {
            addresses = [{
              address = localIPv6_1;
              prefixLength = 64;
            }];
          };

          useDHCP = false;
        };
      };

      firewall = { enable = false; allowedTCPPorts = [ 4000 4999 8000 10000 ]; };
    };
  };
}
