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
  devshellImport = devDependencies: let
    devArgs = builtins.concatMap (
      inputName: [
        "--override-input"
        inputName
        "path:./dev-dependencies/${inputName}"
      ]
    ) (builtins.attrNames devDependencies);
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
      help = "${name} using the dev input overrides and git submodules";
    };
    mkProdDeployCmd = name: subcommand: {
      name = "prod-${name}";
      command = ''
        ${argToFragmentShell "\${1:-}"}
        exec deploy --keep-result .$fragment ${subcommand};
      '';
      help = "${name} using the production inputs";
    };
    devUpdateCommands = nixpkgs.lib.mapAttrsToList (inputName: mapping:
      {
        name = "dev-update-${inputName}";
        command = ''
          set -ex
          git submodule update --init --merge -- \
            $(git rev-parse --show-toplevel)/dev-dependencies/${inputName}
        '';
        help = "Update dev submodule of ${inputName} from ${mapping.url}@${mapping.branch}";
      }
    ) devDependencies;
    prodIntegCommands = nixpkgs.lib.mapAttrsToList (inputName: mapping:
      {
        name = "prod-integ-${inputName}";
        command = ''
          set -ex
          (
            cd $(git rev-parse --show-toplevel)/dev-dependencies/${inputName}
            git push $@ ${mapping.prodUrl} HEAD:${mapping.prodBranch}
          )
          cd $(git rev-parse --show-toplevel)
          prod-update-${inputName}
        '';
        help = "Integrate ${inputName} dev checkout into ${mapping.prodBranch} and update the input";
      }
    ) devDependencies;
    prodUpdateCommands = nixpkgs.lib.mapAttrsToList (inputName: mapping:
      {
        name = "prod-update-${inputName}";
        command = ''
          set -ex
          cd $(git rev-parse --show-toplevel)
          nix flake lock --update-input ${inputName}
        '';
        help = "Update the input ${inputName}";
      }
    ) devDependencies;
  in {
    commands = devUpdateCommands ++ prodIntegCommands ++ prodUpdateCommands ++ [
      {
        name = "dev-build";
        command = ''
          if [ -n  "''${1:-}" ] ; then
            fragment="#nixosConfigurations.$1.config.system.build.toplevel"
          else
            fragment=""
          fi
          exec nix build ${devArgsShell} --show-trace .?submodules=1$fragment
        '';
        help = "Build using the dev input overrides and git submodules";
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

  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
