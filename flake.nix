{
  description = "coreyoconnor's nixos configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    deploy-rs.url = "github:serokell/deploy-rs";

    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/master";
    retronix.url = "github:coreyoconnor/retronix/main";
    sway-gnome.url = "github:coreyoconnor/sway-gnome/main";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    deploy-rs,
    devshell,
    flake-utils,
    nixos-hardware,
    retronix,
    sway-gnome,
  } @ inputs:
    {
      lib = let
        system = name: attrs:
          nixpkgs.lib.nixosSystem ({
            specialArgs = inputs;
            modules = [self.nixosModules.default "${self}/computers/${name}"];
          } // attrs);
        node = name: attrs: ({
          hostname = name;
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
          };
        } // attrs);
        nixosConfigurations = nodes: builtins.mapAttrs system nodes;
        deployNodes = nodes: builtins.mapAttrs node nodes;
      in {
        inherit system node nixosConfigurations deployNodes;
      };
      nixosModules = {
        default = {
          imports = [
            ./defaults
            ./modules
          ];
        };
      };
      nixosConfigurations = self.lib.nixosConfigurations {
        agh = { system = "x86_64-linux"; };
        deny = { system = "x86_64-linux"; };
        glowness = { system = "x86_64-linux"; };
        grr = { system = "x86_64-linux"; };
        thrash = { system = "x86_64-linux"; };
      };
      deploy.nodes = self.lib.deployNodes {
        agh = {};
        deny = {};
        glowness = {};
        grr = {};
        thrash = {};
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlays.default
        ];
      };
    in
      with nixpkgs.lib; {
        formatter = nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
          exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
            --exclude ./dev-dependencies \
            --exclude ./.git \
            "$@"
        '';

        devShells.default = let
          devArgs = [
            "--override-input"
            "nixpkgs"
            "path:./dev-dependencies/nixpkgs"
            "--override-input"
            "nixos-hardware"
            "path:./dev-dependencies/nixos-hardware"
            "--override-input"
            "retronix"
            "path:./dev-dependencies/retronix"
            "--override-input"
            "sway-gnome"
            "path:./dev-dependencies/sway-gnome"
          ];
          devArgsShell = concatStringsSep " " devArgs;
        in
          pkgs.devshell.mkShell {
            imports = [
              {
                commands = let
                  deploy-cmd = name: subcommand: {
                    name = "dev-${name}";
                    command = ''
                      if [ -n  "$1" ] ; then
                        fragment="#$1"
                      else
                        fragment=""
                      fi
                      exec deploy .?submodules=1$fragment ${subcommand} -- ${devArgsShell};
                    '';
                  };
                in [
                  {
                    name = "dev-build";
                    command = "nix build .?submodules=1 ${devArgsShell}";
                  }
                  (deploy-cmd "apply" "")
                  (deploy-cmd "boot" "--boot")
                  (deploy-cmd "dry-run" "--dry-activate")
                ];
              }
              (pkgs.devshell.importTOML ./devshell.toml)
            ];
          };

        packages.default = nixpkgs.legacyPackages.${system}.linkFarm "all-nixos-configurations" (
          nixpkgs.lib.mapAttrsToList (
            node: nixosSystem: {
              name = node;
              path = nixosSystem.config.system.build.toplevel;
            }
          )
          self.nixosConfigurations
        );
      });
}
