{ config, pkgs, lib, ... } :
with lib;
{
  options = {
  };

  config = {
    environment.shellInit =
      let nixConfigDir = cleanSource ./.;
          hostname = config.networking.hostName;
      in ''
        NIX_PATH=nixos=${nixConfigDir}/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixpkgs=${nixConfigDir}/nixpkgs
        NIX_PATH=$NIX_PATH:nixos-config=${nixConfigDir}/computers/${hostname}/configuration.nix
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        NIX_PATH=$NIX_PATH:nixpkgs-overlays=${nixConfigDir}/overlays
        export NIX_PATH
    '';
  };
}
