{
  description = "coreyoconnor's nixos configuration";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/master";
    nix-kube-modules.url = "github:coreyoconnor/nix-kube-modules";
    retronix.url = "github:coreyoconnor/retronix/main";
    sway-gnome = {
      url = "github:coreyoconnor/sway-gnome/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    deploy-rs,
    devshell,
    flake-utils,
    nixos-hardware,
    nix-kube-modules,
    retronix,
    sway-gnome,
  } @ inputs:
    {
      lib = import "${self}/lib" inputs;
      nixosModules = {
        default = {
          imports = [
            ./defaults
            ./modules
          ];
        };
      };
      nixosConfigurations =
        (self.lib.nixosConfigurations {
          deny = {system = "x86_64-linux";};
          glowness = {system = "x86_64-linux";};
          thrash = {system = "x86_64-linux";};
          ufo = {system = "x86_64-linux";};
        })
        // {
          installer-x86-iso = self.lib.nixosConfiguration {
            name = "installer-x86-iso";
            system = "x86_64-linux";
            configPath = "${self}/installer";
          };
          postpi-0-image = self.lib.nixosConfiguration {
            name = "postpi-0-image";
            system = "aarch64-linux";
            configPath = "${self}/computers/postpi-0.nix";
          };
        };
      deploy.nodes = self.lib.deployNodes {
        deny = {};
        glowness = {};
        thrash = {};
        ufo = {remoteBuild = true;};
      };
      checks = self.lib.checks;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          devshell.overlays.default
        ];
      };
      devDependencies = {
        nixos-hardware = {
          url = "git@github.com:coreyoconnor/nixos-hardware";
          branch = "dev";
          # TODO: infer from inputs
          prodUrl = "git@github.com:coreyoconnor/nixos-hardware";
          prodBranch = "master";
        };
        retronix = {
          url = "git@github.com:coreyoconnor/retronix";
          branch = "dev";
          # TODO: infer from inputs
          prodUrl = "git@github.com:coreyoconnor/retronix";
          prodBranch = "main";
        };
        sway-gnome = {
          url = "git@github.com:coreyoconnor/sway-gnome";
          branch = "dev";
          # TODO: infer from inputs
          prodUrl = "git@github.com:coreyoconnor/sway-gnome";
          prodBranch = "main";
        };
        nixpkgs = {
          url = "git@github.com:coreyoconnor/nixpkgs";
          branch = "dev";
          # TODO: infer from inputs
          prodUrl = "git@github.com:coreyoconnor/nixpkgs";
          prodBranch = "main";
          upstreamUrl = "https://github.com/NixOS/nixpkgs.git";
          upstreamBranch = "nixos-24.05";
        };
      };
    in
      with nixpkgs.lib; {
        formatter = self.lib.formatterUsingNativeSystem system;

        devShells.default = pkgs.devshell.mkShell {
          imports = [
            (self.lib.devshellImport devDependencies)
            (pkgs.devshell.importTOML ./devshell.toml)
          ];
        };

        enterShell = ''
          source /etc/profile
        '';

        packages.default = self.lib.allSystemsUsing system;
      });
}
