{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./bretto.nix
    ./coconnor.nix
    ./jenkins.nix
    ./media.nix
  ];
}
