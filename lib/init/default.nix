{ self, devshell, flake-utils, nixpkgs, ... }@inputs: config:
let
  nix_configs = self;
  lib = nix_configs.lib;
in rec {
  nixosModules = {
    default = {
      imports = [
        "${nix_configs}/defaults"
        "${nix_configs}/modules"
      ];
    };
  };

  nixosConfigurations = lib.nixosConfigurations config.systems;

  deploy.nodes = lib.nixosActivations config.systems;

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
