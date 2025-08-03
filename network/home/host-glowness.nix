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
      # the Ids in nixos are not stable
      # defaultGateway.interface = "enp179s0";

      hostId = "4a571618";
    };
  };
}
