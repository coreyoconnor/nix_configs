{
  description = "coreyoconnor's nixos configuration";

  inputs = {
    deploy-rs.url = "github:serokell/deploy-rs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixos-hardware.url = "github:coreyoconnor/nixos-hardware/main";
    nix-kube-modules.url = "github:coreyoconnor/nix-kube-modules";
    retronix = {
      url = "github:coreyoconnor/retronix/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    sway-gnome = {
      url = "github:coreyoconnor/sway-gnome/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, ... }@inputs:
    # for a consumer of this flake this line would be:
    # nix_configs.lib.init inputs {
    (import ./lib/init (inputs // { nix_configs = self; })) {
      systems = {
        deny = {system = "x86_64-linux";};
        glowness = {system = "x86_64-linux";};
        retronix-vm = {system = "x86_64-linux";};
        thrash = {system = "x86_64-linux";};
        ufo = {system = "x86_64-linux";};
        # systems that are not in the `computers/<hostname>` structure:
        installer-x86-iso = {
          name = "installer-x86-iso";
          system = "x86_64-linux";
          configPath = "${self}/installer";
        };
        postpi-0 = {
          name = "postpi-0-image";
          system = "aarch64-linux";
          configPath = "${self}/computers/postpi-0.nix";
        };
      };

      # Can I embed this metadata in the inputs itself?
      devDependencies = {
        nixos-hardware = {
          url = "git@github.com:coreyoconnor/nixos-hardware";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/nixos-hardware";
          prodBranch = "master";
        };
        retronix = {
          url = "git@github.com:coreyoconnor/retronix";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/retronix";
          prodBranch = "main";
        };
        sway-gnome = {
          url = "git@github.com:coreyoconnor/sway-gnome";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/sway-gnome";
          prodBranch = "main";
        };
        nixpkgs = {
          url = "git@github.com:coreyoconnor/nixpkgs";
          branch = "dev";
          prodUrl = "git@github.com:coreyoconnor/nixpkgs";
          prodBranch = "main";
          upstreamUrl = "https://github.com/NixOS/nixpkgs.git";
          upstreamBranch = "nixos-25.05";
        };
      };
    };
}
