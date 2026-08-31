nixpkgs: deploy-rs: inputsMinusSelf: system: pkgs: devFlakes: let
  deploy-rs-pkgs = deploy-rs.packages.${system}.default;
  # the arguments to nix flake build that override the inputs to use the `dev/` submodules
  devOverrideArgs = builtins.concatMap (
    inputName: [
      "--override-input"
      inputName
      "path:./dev/${inputName}"
    ]
  ) (builtins.attrNames devFlakes);
  nixDevInputArgs = pkgs.lib.concatStringsSep " " devOverrideArgs;
  # Fish script builder with substitutions
  builder = (import ./devshell/builder.nix) { inherit pkgs; };
  devBuilder = name: src: {subcommand ? "", ...} @ args:
    builder name src (args // { inherit nixDevInputArgs; });
  prodBuilder = builder;
  # dev build and deploy command builders
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
    package = devBuilder "dev-${name}" ./devshell/dev-nix-build.fish {
      inherit fragmentSplice;
    };
    inherit help;
  };
  mkDevNixBuildPkgCmd = name: {help ? ""}: {
    package = devBuilder "dev-${name}" ./devshell/dev-nix-build-pkg.fish {};
    inherit help;
  };
  # prod build and deploy command builders
  mkProdDeployCmd = name: {
    subcommand ? "",
    help ? "",
  }: {
    package = prodBuilder "prod-${name}" ./devshell/prod-deploy.fish {
      inherit subcommand;
      deploy-rs = deploy-rs-pkgs;
    };
    inherit help;
  };
  mkProdNixBuildCmd = name: {
    fragmentSplice,
    help ? "",
  }: {
    package = prodBuilder "prod-${name}" ./devshell/prod-nix-build.fish {
      inherit fragmentSplice;
    };
    inherit help;
  };
  prodNixBuildPkgCmd = rec {
    name = "build-computer-pkg";
    package = prodBuilder "prod-${name}" ./devshell/prod-nix-build-pkg.fish {};
    help = ''
      Build the pkgs.$argv[2] package from the $argv[1] computer pkgs.
    '';
  };
  # dev-integ-* commands - one per dev flake
  devIntegCommands = nixpkgs.lib.flatten (
    nixpkgs.lib.mapAttrsToList (
      inputName: mapping:
        if (mapping ? upstreamRemote)
        then [
          {
            name = "dev-integ-${inputName}-start";
            package = builder "dev-integ-${inputName}-start" ./devshell/dev-integ-start.fish {
              inherit inputName;
              sourceBranch = mapping.upstreamBranch;
              sourceRemote = mapping.upstreamRemote;
              targetBranch = mapping.branch;
            };
            help = "Start integ dev submodule of ${inputName} from ${mapping.upstreamRemote}@${mapping.upstreamBranch}";
          }
          {
            name = "dev-integ-${inputName}-finish";
            package = builder "dev-integ-${inputName}-finish" ./devshell/dev-integ-finish.fish {
              inherit inputName;
              sourceBranch = mapping.branch;
              targetBranch = mapping.branch;
              targetRemote = mapping.remote;
            };
            help = "Finish integ dev submodule of ${inputName} from ${mapping.upstreamRemote}@${mapping.upstreamBranch}";
          }
        ]
        else []
    )
    devFlakes
  );
  # dev-update-* commands - one per dev flake
  devUpdateCommands =
    nixpkgs.lib.mapAttrsToList (
      inputName: mapping: {
        name = "dev-update-${inputName}";
        command = ''
          set -ex
          git submodule update --init --merge -- \
            $(git rev-parse --show-toplevel)/dev/${inputName}
        '';
        help = "Update dev submodule of ${inputName} from ${mapping.remote}@${mapping.branch}";
      }
    )
    devFlakes;
  # prod-integ-* commands - one per dev flake input
  prodIntegCommands =
    nixpkgs.lib.mapAttrsToList (
      inputName: mapping: {
        package = prodBuilder "prod-integ-${inputName}" ./devshell/prod-integ.fish {
          inherit inputName;
          sourceBranch = mapping.branch;
          targetBranch = mapping.prodBranch;
          targetRemote = mapping.prodRemote;
        };
        help = "Integrate ${inputName} dev checkout into ${mapping.prodBranch} and update the input";
      }
    )
    devFlakes;
  # prod-update-* commands - one per flake input
  prodUpdateCommands = map (
    inputName: {
      package = prodBuilder "prod-update-${inputName}" ./devshell/prod-update.fish {
        inherit inputName;
      };
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
      (mkDevNixBuildCmd "build" {
        fragmentSplice = "#nixosConfigurations.$argv[1].config.system.build.toplevel";
        help = ''
          With dev flake inputs: builds the `config.system.build.toplevel` for the $argv[1] computer.
          Or all toplevels if no $argv[1].
        '';
      })
      (mkDevNixBuildCmd "build-self-pkg" {
        fragmentSplice = "#$argv[1]";
        help = ''
          With dev flake inputs: like `nix build .#$argv[1] $argv[2..-1]`
        '';
      })
      (mkDevNixBuildPkgCmd "build-computer-pkg" {
        help = ''
          With dev flake inputs: build the pkgs.$argv[2] package from the $argv[1] computer pkgs.
        '';
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
      (mkProdNixBuildCmd "build" {
        fragmentSplice = "#nixosConfigurations.$argv[1].config.system.build.toplevel";
        help = ''
          Builds the `config.system.build.toplevel` for the $argv[1] computer.
          Or all toplevels if no $argv[1].
        '';
      })
      (mkProdNixBuildCmd "build-self-pkg" {
        fragmentSplice = "#$argv[1]";
        help = ''
          Like `nix build .#$argv[1] $argv[2..-1]`
        '';
      })
      prodNixBuildPkgCmd
      (mkProdDeployCmd "apply" {
        help = ''
          Like `deploy $argv[2..-1] .#$argv[1]`.
          Which is like `nixos-rebuild apply` for a given computer.
        '';
      })
      (mkProdDeployCmd "boot" {
        subcommand = "--boot";
        help = ''
          Like `deploy $argv[2..-1] --boot .#$argv[1]`.
          Which is like `nixos-rebuild boot` for a given computer.
        '';
      })
      (mkProdDeployCmd "dry-run" {
        subcommand = "--dry-activate";
        help = ''
          Like `deploy $argv[2..-1] --dry-run .#$argv[1]`.
          Which is like `nixos-rebuild dry-run` for a given computer.
        '';
      })
      {
        name = "dev-fetch";
        help = ''
          `git fetch` on all ./dev submodules.
        '';
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
                  if (mapping ? upstreamRemote)
                  then ''
                    echo "Relative to ${mapping.upstreamRemote}/${mapping.upstreamBranch}:"
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
        name = "prod-status";
        command = let
          statusChecks =
            nixpkgs.lib.mapAttrsToList (
              inputName: mapping: let
                upstreamCheck = ''
                  echo "Relative to ${mapping.remote}/${mapping.branch}:"
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
