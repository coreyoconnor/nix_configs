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
        shift
        exec deploy --keep-result .?submodules=1$fragment ${subcommand} -- ${devArgsShell} "$@";
      '';
      help = "${name} using the dev input overrides and git submodules";
    };
    mkProdDeployCmd = name: subcommand: {
      name = "prod-${name}";
      command = ''
        ${argToFragmentShell "\${1:-}"}
        shift
        exec deploy --keep-result .$fragment ${subcommand} "$@";
      '';
      help = "${name} using the production inputs";
    };
    devIntegCommands = nixpkgs.lib.flatten (
      nixpkgs.lib.mapAttrsToList (inputName: mapping:
        if (mapping ? upstreamUrl) then [
          {
            name = "dev-integ-${inputName}-start";
            command = ''
              set -ex
              (
                cd $(git rev-parse --show-toplevel)/dev-dependencies
                baseSha=$(cat ${inputName}-base-sha.txt)
                echo "rebase from base: $baseSha"
                cd ${inputName}
                git fetch upstream
                git show '--format=%H' upstream/${mapping.upstreamBranch} > ../${inputName}-base-next-sha.txt
                git rebase --interactive --onto upstream/${mapping.upstreamBranch} $baseSha ${mapping.branch}
              )
            '';
            help = "Start integ dev submodule of ${inputName} from ${mapping.upstreamUrl}@${mapping.upstreamBranch}";
          }
          {
            name = "dev-integ-${inputName}-finish";
            command = ''
              set -ex
              (
                cd $(git rev-parse --show-toplevel)/dev-dependencies
                (
                  cd ${inputName}
                  git push -f origin HEAD
                )
                cp ${inputName}-base-next-sha.txt ${inputName}-base-sha.txt
                git add ${inputName}*
                git commit ${inputName}* -m 'update ${inputName}'
              )
            '';
            help = "Finish integ dev submodule of ${inputName} from ${mapping.upstreamUrl}@${mapping.upstreamBranch}";
          }
        ] else []
      ) devDependencies
    );
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
    prodUpdateCommands = map (inputName:
      {
        name = "prod-update-${inputName}";
        command = ''
          set -ex
          cd $(git rev-parse --show-toplevel)
          nix flake lock --update-input ${inputName}
        '';
        help = "Update the input ${inputName}";
      }
    ) (builtins.filter (n: n != "self") (builtins.attrNames inputs));
  in {
    commands = devIntegCommands ++ devUpdateCommands ++ prodIntegCommands ++ prodUpdateCommands ++ [
      {
        name = "dev-nixpkgs-build";
        command = ''
          fragment="#$1"
          shift
          exec nix build ${devArgsShell} --show-trace .?submodules=1$fragment "$@"
        '';
      }
      {
        name = "dev-build";
        command = ''
          if [ -n  "''${1:-}" ] ; then
            fragment="#nixosConfigurations.$1.config.system.build.toplevel"
          else
            fragment=""
          fi
          shift
          exec nix build ${devArgsShell} --show-trace .?submodules=1$fragment "$@"
        '';
        help = "Build using the dev input overrides and git submodules";
      }
      (mkDevDeployCmd "apply" "")
      (mkDevDeployCmd "boot" "--boot")
      (mkDevDeployCmd "dry-run" "--dry-activate")
      {
        name = "dev-fetch";
        command =
          let
            inputDirs = builtins.attrNames devDependencies;
          in ''
            cd $(git rev-parse --show-toplevel)/dev-dependencies
            for I in ${builtins.concatStringsSep " " inputDirs} ; do
              echo $I
              (
                cd $I
                git fetch --all
              )
            done
          '';
      }
      {
        name = "dev-status";
        command =
          let
            statusChecks = nixpkgs.lib.mapAttrsToList (inputName: mapping:
              let upstreamCheck = if (mapping ? upstreamUrl) then ''
                  echo "Relative to ${mapping.upstreamUrl}/${mapping.upstreamBranch}:"
                  echo -e "Behind\tAhead"
                  git rev-list --count --left-right upstream/${mapping.upstreamBranch}...HEAD
                '' else "";
              in ''
              (
                echo ${inputName}
                cd ${inputName}
                git status
                ${upstreamCheck}
              )
              ''
            ) devDependencies;
          in ''
            cd $(git rev-parse --show-toplevel)/dev-dependencies
            ${builtins.concatStringsSep "\n\n" statusChecks}
          '';
      }
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
