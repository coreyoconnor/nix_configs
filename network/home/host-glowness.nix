{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  localIPv4_0 = "192.168.88.18";
in {
  imports = [./default.nix];

  config = {
    networking = {
      defaultGateway.interface = "enp9s0";

      hostId = "4a571618";
    };
  };
}
