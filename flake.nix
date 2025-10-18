{
  description = "coreyoconnor's nixos configuration library";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    deploy-rs.url = "github:serokell/deploy-rs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, ... }@inputs:
  let
    lib = import ./lib inputs;
  in (lib.mkFlake inputs {}) // {
    inherit lib;
  };
}
