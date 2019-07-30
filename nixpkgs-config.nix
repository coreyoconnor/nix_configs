{config, pkgs, lib, ...} :
with lib;
let nixConfigsDir = cleanSource ./.;
    hostname = config.networking.hostName;
in rec {
  options = {
  };

  config =
  {
    nixpkgs = import ./nixpkgs-config { inherit config pkgs lib; };

    system.activationScripts = {
      nixpath = {
        text = ''
          ln -sfn ${nixConfigsDir} /etc/nixos/nix_configs
          ln -sfn /etc/nixos/nix_configs/computers/${hostname}/configuration.nix /etc/nixos/configuration.nix
        '';
        deps = [];
      };
    };

    environment.shellInit = ''
        NIX_PATH=nixos=/etc/nixos/nix_configs/nixpkgs/nixos
        NIX_PATH=$NIX_PATH:nixpkgs=/etc/nixos/nix_configs/nixpkgs
        NIX_PATH=$NIX_PATH:nixos-config=/etc/nixos/configuration.nix
        NIX_PATH=$NIX_PATH:services=/etc/nixos/services
        NIX_PATH=$NIX_PATH:nixpkgs-overlays=/etc/nixos/nix_configs/nixpkgs-config/overlays
        export NIX_PATH
    '';
  };
}
