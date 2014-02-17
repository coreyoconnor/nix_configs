{ config, pkgs, ... } :
with pkgs.lib;
{
  options =
  {
    environment.systemConfigName = mkOption
    {
      default = "";
      example = "toast-config.nix";
      type = with types; string;
    };
  };

  config =
  {
    environment.shellInit = ''
        NIX_PATH=nixos=/home/coconnor/Development/nix_configs/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixos-config=/home/coconnor/Development/nix_configs/${config.environment.systemConfigName}
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        NIX_PATH=$NIX_PATH:nixpkgs=/home/coconnor/Development/nix_configs/nixpkgs
        export NIX_PATH
    '';
  };
}
