{ config, pkgs, ... } :
with pkgs.lib;
{
  options =
  {
    environment.computerName = mkOption
    {
      default = "";
      example = "toast";
      type = with types; string;
    };

    environment.nixConfigsDir = mkOption
    {
      default = "/home/coconnor/Development/nix_configs";
      type = with types; string;
    };
  };

  config =
  {
    environment.shellInit =
        let dir = config.environment.nixConfigsDir;
            comp = config.environment.computerName;
        in ''
        NIX_PATH=nixos=${dir}/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixpkgs=${dir}/nixpkgs
        NIX_PATH=$NIX_PATH:nixos-config=${dir}/computers/${comp}/configuration.nix
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        export NIX_PATH
    '';
  };
}
