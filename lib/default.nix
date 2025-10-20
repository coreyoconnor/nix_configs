{
  nixpkgs,
  deploy-rs,
  ...
} @ nix_configs_inputs:
with nixpkgs.lib; let
  formatterUsingNativeSystem = system:
    nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
      #!/bin/sh
      exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
        --exclude ./dev \
        --exclude ./.git \
        --exclude ./result \
        --exclude ./.bsp \
        --exclude ./.deploy-gc \
        --exclude ./.gcroots \
        --exclude ./.metals \
        --exclude ./.doc \
        "$@"
    '';
in {
  inherit formatterUsingNativeSystem;

  mkFlake = import ./mkFlake.nix nix_configs_inputs;
}
