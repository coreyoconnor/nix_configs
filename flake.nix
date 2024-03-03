{
  description = "coreyoconnor's nixos configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    deploy-rs.url = "github:serokell/deploy-rs";

    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/master";
    retronix.url = "github:coreyoconnor/retronix/main";
    sway-gnome.url = "github:coreyoconnor/sway-gnome/main";
  };

  outputs = { self, nixpkgs, deploy-rs, devshell, flake-utils, nixos-hardware, retronix, sway-gnome }:
    {
      nixosModules = {
        default = {
          imports = [
            ./defaults ./modules
          ];
        };
      };
      nixosConfigurations = {
        grr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ self.nixosModules.default ./computers/grr ];
        };
      };
      deploy.nodes = {
        grr.profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.grr;
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    } // flake-utils.lib.eachDefaultSystem (system: {
      devShell =
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              devshell.overlays.default
            ];
          };
        in with nixpkgs.lib;
        let
          devArgs = [
            "--override-input" "nixpkgs" "path:./dev-dependencies/nixpkgs"
            "--override-input" "nixos-hardware" "path:./dev-dependencies/nixos-hardware"
            "--override-input" "retronix" "path:./dev-dependencies/retronix"
            "--override-input" "sway-gnome" "path:./dev-dependencies/sway-gnome"
          ];
          devArgsShell = concatStringsSep " " devArgs;
        in pkgs.devshell.mkShell {
          imports = [
            {
              commands = [
                {
                  name = "dev-build";
                  command = "deploy .?submodules=1 --dry-activate -- ${concatStringsSep " " devArgs} \"$@\"";
                }
                {
                  name = "dev-boot";
                  command = "deploy .?submodules=1 --boot -- ${concatStringsSep " " devArgs} \"$@\"";
                }
              ];
            }
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };
    });
}
