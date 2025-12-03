{
  description = "coreyoconnor's nixos configuration library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
          url = "git@github.com:coreyoconnor/nixpkgs";
          branch = "nixos-25.11";
          prodUrl = "https://github.com/NixOS/nixpkgs.git";
          prodBranch = "nixos-25.11";
          upstreamUrl = "https://github.com/NixOS/nixpkgs.git";
          upstreamBranch = "nixos-25.11";
        };
      };
    })
    // {
      inherit lib;
    };
}
