{ devshell, flake-utils, nixpkgs, ... }@nix_config_inputs: inputs: config:
let
  default_config = {
    systems = {};
    devFlakes = {};
    overlays = [];
    mkDevshellImports = devshell: [];
    mkPackages = system: pkgs: {};
  };
  final_config = default_config // config;
  nix_configs = nix_config_inputs.self;
  lib = nix_configs.lib;
  builders = (import ./mkBuilders.nix nix_configs_inputs) inputs;
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

  nixosConfigurations = builders.nixosConfigurations final_config.systems;

  deploy.nodes = builders.nixosActivations final_config.systems;

  checks = lib.checks;
} // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        devshell.overlays.default
      ] ++ final_config.overlays;
    };
    in {
        formatter = lib.formatterUsingNativeSystem system;

        devShells.default = pkgs.devshell.mkShell {
          imports = [
            (builders.devshellImport final_config.devFlakes)
            (pkgs.devshell.importTOML ./default-devshell.toml)
          ] ++ (final_config.mkDevshellImports system pkgs);
        };

        packages = {
          default = builders.allSystemsUsing system;
        } // (final_config.mkPackages system pkgs);
    })
