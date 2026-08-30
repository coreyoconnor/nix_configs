{
  nixpkgs,
  deploy-rs,
  ...
} @ nix_configs_inputs:
with nixpkgs.lib; let
  formatterUsingNativeSystem = system:
    nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
      #!/bin/sh
      cd $(git rev-parse --show-toplevel)

      gitExcludes=$(cat .gitignore | awk '{print "--exclude " $1;}')
      exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
        --exclude ./dev \
        --exclude ./.git \
        $gitExcludes \
        "$@"
    '';
in {
  inherit formatterUsingNativeSystem;

  mkFlake = import ./mkFlake.nix nix_configs_inputs;
}
