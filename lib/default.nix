{
  self,
  nixpkgs,
  deploy-rs,
  ...
} @ inputs:
with nixpkgs.lib; let
  nixosConfiguration = {
    name,
    system,
    configPath ? "${self}/computers/${name}",
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = inputs;
      modules = [self.nixosModules.default configPath];
      inherit system;
    };
  node = name: attrs: ({
      hostname = name;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
      };
    }
    // attrs);
  nixosConfigurations = nodes: builtins.mapAttrs (node: attrs: nixosConfiguration ({name = node;} // attrs)) nodes;
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
        exec deploy --keep-result .?submodules=1$fragment ${subcommand} -- ${devArgsShell};
      '';
    };
    mkProdDeployCmd = name: subcommand: {
      name = "prod-${name}";
      command = ''
        ${argToFragmentShell "\${1:-}"}
        exec deploy --keep-result .$fragment ${subcommand};
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
          exec nix build --show-trace .?submodules=1$fragment
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
          exec nix build --show-trace .$fragment
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
  allSystemsUsing = system:
    nixpkgs.legacyPackages.${system}.linkFarm "all-nixos-configurations" (
      nixpkgs.lib.mapAttrsToList (
        node: nixosSystem: {
          name = node;
          path =
            if (nixpkgs.lib.hasSuffix "-image" node)
            then nixosSystem.config.system.build.sdImage
            else if (nixpkgs.lib.hasSuffix "-iso" node)
              then nixosSystem.config.system.build.isoImage
              else nixosSystem.config.system.build.toplevel;
        }
      )
      self.nixosConfigurations
    );
in {
  inherit
    allSystemsUsing
    deployNodes
    devshellImport
    formatterUsingNativeSystem
    nixosConfiguration
    nixosConfigurations
    node
    ;
}
