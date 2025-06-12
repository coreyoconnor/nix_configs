{ devshell, flake-utils, nixpkgs, ... }@nix_config_inputs: inputs: config:
let
  nix_configs = nix_config_inputs.self;
  lib = nix_configs.lib;
  builder = lib.builder inputs;
in rec {
  nixosModules = {
    default = {
      imports = [
        "${nix_configs}/defaults"
        "${nix_configs}/modules"
      ] ++ (
        if (builtins.pathExists "${inputs.self}/defaults")
          then [ "${inputs.self}/defaults" ]
          else []
      ) ++ (
        if (builtins.pathExists "${inputs.self}/modules")
          then [ "${inputs.self}/modules" ]
          else []
      );
    };
  };

  nixosConfigurations = builder.nixosConfigurations config.systems;

  deploy.nodes = builder.nixosActivations config.systems;

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
            (builder.devshellImport ( { devDependencies = {}; } // config ).devDependencies)
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };

        enterShell = ''
          source /etc/profile
        '';

        packages.default = builder.allSystemsUsing system;
    })
