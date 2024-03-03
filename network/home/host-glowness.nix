{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  localIPv4_0 = "192.168.86.3";
  localIPv6_0 = "2601:602:9700:f0fc::3";
in {
  imports = [./default.nix];

  config = {
    networking = {
      defaultGateway.interface = "enp4s0";

      enableIPv6 = true;

      hostId = "4a571618";
    };
  };
}
