{ config, lib, pkgs, ... }:
with lib;
let
  localIPv4_0 = "192.168.86.3";
  localIPv6_0 = "2601:602:9700:f0fc::3";
in {
  imports = [ ./default.nix ];

  config = {
    networking = {
      enableIPv6 = true;

      hostId = "4a571618";

      useNetworkd = true;
    };

    systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart = [
      "" # clear old command
      "${config.systemd.package}/lib/systemd/systemd-networkd-wait-online -i enp4s0"
    ];
  };
}
