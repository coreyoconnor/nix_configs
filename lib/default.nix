{
  self,
  nixpkgs,
  deploy-rs,
  ...
} @ inputs:
with nixpkgs.lib; let
  inputsMinusSelf = builtins.removeAttrs inputs ["self"];
  nixosConfiguration = {
    name,
    system,
    configPath ? "${self}/computers/${name}",
    ...
  }:
    nixpkgs.lib.nixosSystem {
      specialArgs = inputsMinusSelf // {inputs = inputsMinusSelf;};
      modules = [self.nixosModules.default configPath];
      inherit system;
    };
  nixosActivation = systemName: systemConfig: ({
      hostname = systemName;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.${systemConfig.system}.activate.nixos self.nixosConfigurations.${systemName};
      };
    }
    // systemConfig);
  nixosConfigurationWithName = systemName: systemConfig: nixosConfiguration ({name = systemName;} // systemConfig);
  nixosConfigurations = nodes: builtins.mapAttrs nixosConfigurationWithName nodes;
  nixosActivations = nodes: builtins.mapAttrs nixosActivation (
    attrsets.filterAttrs (systemName: systemConfig:
      if (systemConfig ? "imageBuild") then !systemConfig.imageBuild else true
    ) nodes
  );
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
        if [ -n "$fragment" ] ; then
          shift
        fi
        exec deploy --skip-checks --auto-rollback false --keep-result .?submodules=1$fragment ${subcommand} -- ${devArgsShell} "$@";
      '';
      help = "${name} using the dev input overrides and git submodules";
    };
    mkProdDeployCmd = name: subcommand: {
      name = "prod-${name}";
      command = ''
        ${argToFragmentShell "\${1:-}"}
        if [ -n "$fragment" ] ; then
          shift
        fi
        exec deploy --skip-checks --auto-rollback false --keep-result .$fragment ${subcommand} "$@";
      '';
      help = "${name} using the production inputs";
    };
    devBuildVMCmd = {
      name = "dev-build-vm";
      command = ''
        if [ -n  "$1" ] ; then
          fragment="#$1"
          shift
        else
          echo "requires computer to build vm for"
          exit 1
        fi
        exec nixos-rebuild build-vm --flake .?submodules=1$fragment ${devArgsShell} "$@";
      '';
      help = "build vm launcher";
    };
    devIntegCommands = nixpkgs.lib.flatten (
      nixpkgs.lib.mapAttrsToList (
        inputName: mapping:
          if (mapping ? upstreamUrl)
          then [
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
          ]
          else []
      )
      devDependencies
    );
    devUpdateCommands =
      nixpkgs.lib.mapAttrsToList (
        inputName: mapping: {
          name = "dev-update-${inputName}";
          command = ''
            set -ex
            git submodule update --init --merge -- \
              $(git rev-parse --show-toplevel)/dev-dependencies/${inputName}
          '';
          help = "Update dev submodule of ${inputName} from ${mapping.url}@${mapping.branch}";
        }
      )
      devDependencies;
    prodIntegCommands =
      nixpkgs.lib.mapAttrsToList (
        inputName: mapping: {
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
      )
      devDependencies;
    prodUpdateCommands = map (
      inputName: {
        name = "prod-update-${inputName}";
        command = ''
          set -ex
          cd $(git rev-parse --show-toplevel)
          nix flake lock --update-input ${inputName}
        '';
        help = "Update the input ${inputName}";
      }
    ) (builtins.attrNames inputsMinusSelf);
  in {
    commands =
      devIntegCommands
      ++ devUpdateCommands
      ++ prodIntegCommands
      ++ [
        (
          let
            allIntegs = builtins.attrNames devDependencies;
            allUpdates = builtins.attrNames (builtins.removeAttrs inputsMinusSelf allIntegs);
            integCmds = builtins.map (n: "prod-integ-${n}") allIntegs;
            updateCmds = builtins.map (n: "prod-update-${n}") allUpdates;
          in {
            name = "prod-integ-all";
            command = ''
              set -ex
              echo all integs
              ${builtins.concatStringsSep "\n" integCmds}
              echo remaining updates
              ${builtins.concatStringsSep "\n" updateCmds}
            '';
            help = "Integrate all dev checkouts and update all the inputs.";
          }
        )
      ]
      ++ prodUpdateCommands
      ++ [
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
              shift
            else
              fragment=""
            fi
            exec nix build ${devArgsShell} --show-trace .?submodules=1$fragment "$@"
          '';
          help = "Build using the dev input overrides and git submodules";
        }
        (mkDevDeployCmd "apply" "")
        (mkDevDeployCmd "boot" "--boot")
        (mkDevDeployCmd "dry-run" "--dry-activate")
        {
          name = "dev-fetch";
          command = let
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
          command = let
            statusChecks =
              nixpkgs.lib.mapAttrsToList (
                inputName: mapping: let
                  upstreamCheck =
                    if (mapping ? upstreamUrl)
                    then ''
                      echo "Relative to ${mapping.upstreamUrl}/${mapping.upstreamBranch}:"
                      echo -e "Behind\tAhead"
                      git rev-list --count --left-right upstream/${mapping.upstreamBranch}...HEAD
                    ''
                    else "";
                in ''
                  (
                    echo -e "\t${inputName}"
                    cd ${inputName}
                    git status
                    ${upstreamCheck}
                    echo
                  )
                ''
              )
              devDependencies;
          in ''
            cd $(git rev-parse --show-toplevel)/dev-dependencies
            ${builtins.concatStringsSep "\n\n" statusChecks}
          '';
        }
        devBuildVMCmd
        {
          name = "prod-build";
          command = ''
            if [ -n  "''${1:-}" ] ; then
              fragment="#nixosConfigurations.$1.config.system.build.toplevel"
              outlink=$fragment
              shift
            else
              fragment=""
              outlink=all
            fi
            mkdir -p .gcroots
            exec nix build --out-link .gcroots/$outlink --show-trace .$fragment "$@"
          '';
        }
        (mkProdDeployCmd "apply" "")
        (mkProdDeployCmd "boot" "--boot")
        (mkProdDeployCmd "dry-run" "--dry-activate")
        {
          name = "prod-status";
          command = let
            statusChecks =
              nixpkgs.lib.mapAttrsToList (
                inputName: mapping: let
                  upstreamCheck = ''
                    echo "Relative to ${mapping.url}/${mapping.branch}:"
                    echo '`main` relative to `dev` is'
                    echo -e "Behind\tAhead"
                    git rev-list --count --left-right origin/${mapping.branch}...origin/${mapping.prodBranch}
                  '';
                in ''
                  (
                    echo -e "\t${inputName}"
                    cd ${inputName}
                    git fetch origin
                    echo 'local `dev` related to `origin/dev` is'
                    echo -e "Behind\tAhead"
                    git rev-list --count --left-right ${mapping.branch}...origin/${mapping.branch}
                    ${upstreamCheck}
                    echo
                  )
                ''
              )
              devDependencies;
          in ''
            cd $(git rev-parse --show-toplevel)/dev-dependencies
            ${builtins.concatStringsSep "\n\n" statusChecks}

            echo -e "\tnix_configs"
            git fetch origin
            echo 'local `dev` related to `origin/dev` is'
            echo -e "Behind\tAhead"
            git rev-list --count --left-right dev...origin/dev
            echo '`main` relative to `dev` is'
            echo -e "Behind\tAhead"
            git rev-list --count --left-right origin/dev...origin/main
          '';
        }
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
    nixosActivation
    nixosActivations
    devshellImport
    formatterUsingNativeSystem
    nixosConfiguration
    nixosConfigurations
    node
    ;

  init = import ./init inputs;

  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
}
