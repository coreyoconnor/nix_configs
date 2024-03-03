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
      nixosModules = {
        default = {
          imports = [
            ./defaults
            ./modules
          ];
        };
      };
      nixosConfigurations = let
        mkSystem = system: name:
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = inputs;
            modules = [self.nixosModules.default "${self}/computers/${name}"];
          };
      in {
        agh = mkSystem "x86_64-linux" "agh";
        deny = mkSystem "x86_64-linux" "deny";
        glowness = mkSystem "x86_64-linux" "glowness";
        grr = mkSystem "x86_64-linux" "grr";
        thrash = mkSystem "x86_64-linux" "thrash";
      };
      deploy.nodes = let
        mkNode = name: {
          hostname = "${name}.local";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${name};
          };
        };
      in {
        agh = mkNode "agh";
        deny = mkNode "deny";
        glowness = mkNode "glowness";
        grr = mkNode "grr";
        thrash = mkNode "thrash";
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.writeScriptBin "alejandra" ''
        exec ${nixpkgs.legacyPackages.${system}.alejandra}/bin/alejandra \
          --exclude ./dev-dependencies/nixpkgs \
          --exclude ./dev-dependencies/nixos-hardware \
          --exclude ./.git \
          "$@"
      '';

      devShells.default = let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            devshell.overlays.default
          ];
        };
      in
        with nixpkgs.lib; let
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
                commands = [
                  {
                    name = "dev-build";
                    command = "deploy .?submodules=1 --dry-activate -- ${concatStringsSep " " devArgs} \"$@\"";
                  }
                  {
                    name = "dev-boot";
                    command = "deploy .?submodules=1 --boot -- ${concatStringsSep " " devArgs} \"$@\"";
                  }
                ];
              }
              (pkgs.devshell.importTOML ./devshell.toml)
            ];
          };
    });
}
