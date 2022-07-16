{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./bretto.nix
    ./coconnor.nix
    ./media.nix
    ./nix.nix
  ];
}
