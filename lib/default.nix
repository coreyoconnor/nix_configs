{
  nixpkgs,
  deploy-rs,
  ...
} @ nix_configs_inputs:
with nixpkgs.lib; let
  formatterUsingNativeSystem = system:
    nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
      exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
        --exclude ./dev \
        --exclude ./.git \
        "$@"
    '';
in {
  inherit formatterUsingNativeSystem;

  mkFlake = import ./mkFlake.nix nix_configs_inputs;
}
