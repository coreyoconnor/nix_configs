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
        system = name: attrs: let
          configPath =
            if attrs ? configPath
            then attrs.configPath
            else "${self}/computers/${name}";
        in
          nixpkgs.lib.nixosSystem ({
              specialArgs = inputs;
              modules = [self.nixosModules.default configPath];
            }
            // (builtins.removeAttrs attrs ["configPath"]));
        node = name: attrs: ({
            hostname = name;
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
            };
          }
          // attrs);
        nixosConfigurations = nodes: builtins.mapAttrs system nodes;
        deployNodes = nodes: builtins.mapAttrs node nodes;
        devshellImport = overrides: let
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
          devArgsShell = nixpkgs.lib.concatStringsSep " " devArgs;
          argToFragmentShell = arg: ''
            if [ -n  "${arg}" ] ; then
              fragment="#${arg}"
            else
              fragment=""
            fi
          '';
          mkDevDeployCmd = name: subcommand: {
            name = "dev-${name}";
            command = ''
              ${argToFragmentShell "\${1:-}"}
              exec deploy .?submodules=1$fragment ${subcommand} -- ${devArgsShell};
            '';
          };
          mkProdDeployCmd = name: subcommand: {
            name = "prod-${name}";
            command = ''
              ${argToFragmentShell "\${1:-}"}
              exec deploy .$fragment ${subcommand};
            '';
          };
        in {
          commands = [
            {
              name = "dev-build";
              command = ''
                if [ -n  "''${1:-}" ] ; then
                  fragment="#nixosConfigurations.$1.config.system.build.toplevel"
                else
                  fragment=""
                fi
                exec nix build .?submodules=1$fragment --show-trace
              '';
            }
            (mkDevDeployCmd "apply" "")
            (mkDevDeployCmd "boot" "--boot")
            (mkDevDeployCmd "dry-run" "--dry-activate")
            {
              name = "prod-build";
              command = ''
                if [ -n  "''${1:-}" ] ; then
                  fragment="#nixosConfigurations.$1.config.system.build.toplevel"
                else
                  fragment=""
                fi
                exec nix build .$fragment
              '';
            }
            (mkProdDeployCmd "apply" "")
            (mkProdDeployCmd "boot" "--boot")
            (mkProdDeployCmd "dry-run" "--dry-activate")
          ];
        };
        formatterUsingNativeSystem = system:
          nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
            exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
              --exclude ./dev-dependencies \
              --exclude ./.git \
              "$@"
          '';
        allSystemsUsingNativeSystem = system:
          nixpkgs.legacyPackages.${system}.linkFarm "all-nixos-configurations" (
            nixpkgs.lib.mapAttrsToList (
              node: nixosSystem: {
                name = node;
                path =
                  if (nixpkgs.lib.hasSuffix "-image" node)
                  then nixosSystem.config.system.build.isoImage
                  else nixosSystem.config.system.build.toplevel;
              }
            )
            self.nixosConfigurations
          );
      in {
        inherit
          system
          node
          nixosConfigurations
          deployNodes
          devshellImport
          formatterUsingNativeSystem
          allSystemsUsingNativeSystem
          ;
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
        agh = {system = "x86_64-linux";};
        deny = {system = "x86_64-linux";};
        glowness = {system = "x86_64-linux";};
        grr = {system = "x86_64-linux";};
        thrash = {system = "x86_64-linux";};
        nixos-installer-x86-image = {
          system = "x86_64-linux";
          configPath = "${self}/installer";
        };
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
        formatter = self.lib.formatterUsingNativeSystem system;

        devShells.default = pkgs.devshell.mkShell {
          imports = [
            (self.lib.devshellImport {})
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };

        packages.default = self.lib.allSystemsUsingNativeSystem system;
      });
}
