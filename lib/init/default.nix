{ nixpkgs, flake-utils, devshell, nix_configs, ... }@inputs: config:
let
  self = nix_configs;
  lib = import "${self}/lib" inputs;
  deploy-nodes = {
    deny = {};
    glowness = {};
    thrash = {};
    ufo = {remoteBuild = true;};
  };
  standard-configs = nixpkgs.lib.attrsets.filterAttrs (system: !(builtins.hasAttr "name")) config.systems;
  non-standard-configs = nixpkgs.lib.attrsets.filterAttrs (system: builtins.hasAttr "name") config.systems;
in rec {
  inherit lib;

  nixosModules = {
    default = {
      imports = [
        "${self}/defaults"
        "${self}/modules"
      ];
    };
  };

  nixosConfigurations = (lib.nixosConfigurations standard-configs) // non-standard-configs;

  deploy.nodes = lib.deployNodes deploy-nodes;

  checks = lib.checks;
} // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        devshell.overlays.default
      ];
    };
    in {
        formatter = lib.formatterUsingNativeSystem system;

        devShells.default = pkgs.devshell.mkShell {
          imports = [
            (lib.devshellImport config.devDependencies)
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };

        enterShell = ''
          source /etc/profile
        '';

        packages.default = lib.allSystemsUsing system;
    })
