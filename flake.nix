{
  description = "coreyoconnor's nixos configuration library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    deploy-rs.url = "github:serokell/deploy-rs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, ...} @ inputs: let
    lib = import ./lib inputs;
  in
    (lib.mkFlake inputs {
      devFlakes = {
        nixpkgs = {
          remote = "git@github.com:coreyoconnor/nixpkgs";
          branch = "dev";
          prodRemote = "git@github.com:coreyoconnor/nixpkgs";
          prodBranch = "nixos-26.05";
          upstreamRemote = "https://github.com/NixOS/nixpkgs.git";
          upstreamBranch = "nixos-26.05";
        };
      };
    })
    // {
      inherit lib;
    };
}
