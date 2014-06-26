{ config, pkgs, ... } :
with pkgs.lib;
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
        let dir = config.environment.nixConfigsDir;
            hostname = config.networking.hostName;
        in ''
        NIX_PATH=nixos=${dir}/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixpkgs=${dir}/nixpkgs
        NIX_PATH=$NIX_PATH:nixos-config=${dir}/computers/${hostname}/configuration.nix
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        export NIX_PATH
    '';
  };
}
