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
          agh = {system = "x86_64-linux";};
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
        agh = { autoRollback = false; magicRollback = false; };
        # deny = {};
        glowness = {};
        # thrash = {};
        ufo = { remoteBuild = true; };
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
          upstreamBranch = "release-23.11";
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

        packages.default = self.lib.allSystemsUsing system;
      });
}
