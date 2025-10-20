nixpkgs: deploy-rs: inputsMinusSelf: system: pkgs: devFlakes: let
  deploy-rs-pkgs = deploy-rs.packages.${system}.default;
  argToFragmentShell = arg: "";
  devArgsShell = "";
  devBuilder = (import ./devshell/dev-builder.nix) {
    inherit pkgs devFlakes;
  };
  mkDevDeployCmd = name: {
    subcommand ? "",
    help ? "",
  }: {
    package = devBuilder "dev-${name}" ./devshell/dev-deploy.fish {
      inherit subcommand;
      deploy-rs = deploy-rs-pkgs;
    };
    inherit help;
  };
  mkDevNixBuildCmd = name: {
    fragmentSplice,
    help ? "",
  }: {
    package = devBuilder "dev-nix-${name}" ./devshell/dev-nix-build.fish {
      inherit fragmentSplice;
    };
    inherit help;
  };
  mkDevNixBuildPkgCmd = name: {help ? ""}: {
    package = devBuilder "dev-nix-${name}" ./devshell/dev-nix-build-pkg.fish {};
    inherit help;
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
                cd $(git rev-parse --show-toplevel)/dev
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
                cd $(git rev-parse --show-toplevel)/dev
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
    devFlakes
  );
  devUpdateCommands =
    nixpkgs.lib.mapAttrsToList (
      inputName: mapping: {
        name = "dev-update-${inputName}";
        command = ''
          set -ex
          git submodule update --init --merge -- \
            $(git rev-parse --show-toplevel)/dev/${inputName}
        '';
        help = "Update dev submodule of ${inputName} from ${mapping.url}@${mapping.branch}";
      }
    )
    devFlakes;
  prodIntegCommands =
    nixpkgs.lib.mapAttrsToList (
      inputName: mapping: {
        name = "prod-integ-${inputName}";
        command = ''
          set -ex
          (
            cd $(git rev-parse --show-toplevel)/dev/${inputName}
            git push $@ ${mapping.prodUrl} HEAD:${mapping.prodBranch}
          )
          cd $(git rev-parse --show-toplevel)
          prod-update-${inputName}
        '';
        help = "Integrate ${inputName} dev checkout into ${mapping.prodBranch} and update the input";
      }
    )
    devFlakes;
  prodUpdateCommands = map (
    inputName: {
      name = "prod-update-${inputName}";
      command = ''
        set -ex
        cd $(git rev-parse --show-toplevel)
        nix flake update ${inputName}
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
          allIntegs = builtins.attrNames devFlakes;
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
      (mkDevNixBuildCmd "build-self" {
        fragmentSplice = "#$argv[1]";
        help = "With dev flake inputs: like `nix build .#$argv[1] $argv[2..-1]`";
      })
      (mkDevNixBuildPkgCmd "build-pkg" {
        help = "With dev flake inputs: build the pkgs.$argv[2] package from the $argv[1] computer pkgs.";
      })
      (mkDevNixBuildCmd "build-computer-toplevel" {
        fragmentSplice = "#nixosConfigurations.$argv[1].config.system.build.toplevel";
        help = "With dev flake inputs: builds the `config.system.build.toplevel` for the given computer.";
      })
      (mkDevDeployCmd "apply" {
        help = ''
          With dev flake inputs: like `deploy $argv[2..-1] .#$argv[1]`.
          Which is like `nixos-rebuild apply` for a given computer.
        '';
      })
      (mkDevDeployCmd "boot" {
        subcommand = "--boot";
        help = ''
          With dev flake inputs: like `deploy $argv[2..-1] --boot .#$argv[1]`.
          Which is like `nixos-rebuild boot` for a given computer.
        '';
      })
      (mkDevDeployCmd "dry-run" {
        subcommand = "--dry-activate";
        help = ''
          With dev flake inputs: like `deploy $argv[2..-1] --dry-run .#$argv[1]`.
          Which is like `nixos-rebuild dry-run` for a given computer.
        '';
      })
      {
        name = "dev-fetch";
        command = let
          inputDirs = builtins.attrNames devFlakes;
        in ''
          cd $(git rev-parse --show-toplevel)/dev
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
            devFlakes;
        in ''
          cd $(git rev-parse --show-toplevel)/dev
          ${builtins.concatStringsSep "\n\n" statusChecks}
        '';
      }
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
            devFlakes;
        in ''
          cd $(git rev-parse --show-toplevel)/dev
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
}
