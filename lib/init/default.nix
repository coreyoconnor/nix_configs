{ nix_configs, nix_configs_lib ? nix_configs.lib, ... }@inputs: config:
let
  lib = nix_configs_lib;
  use-standard = attr: if (builtins.hasAttr attr inputs) then inputs.${attr} else nix_configs;
  flake-utils = use-standard "flake-utils";
  # eh. might not be the right one
  nixpkgs = use-standard "nixpkgs";
  devshell = use-standard "devshell";
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
