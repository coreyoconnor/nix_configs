{ config, pkgs, lib, ... } :
with lib;
{
  options =
  {
    environment.nixConfigsDir = mkOption
    {
      default = "/home/admin/nix_configs";
      type = with types; string;
    };
  };

  config =
  {
    environment.shellInit =
      let nix_configs_dir = config.environment.nixConfigsDir;
          hostname = config.networking.hostName;
      in ''
        NIX_PATH=nixos=${nix_configs_dir}/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixpkgs=${nix_configs_dir}/nixpkgs
        NIX_PATH=$NIX_PATH:nixos-config=${nix_configs_dir}/computers/${hostname}/configuration.nix
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        NIX_PATH=$NIX_PATH:nixpkgs-overlays=${nix_configs_dir}/overlays
        export NIX_PATH
    '';
  };
}
