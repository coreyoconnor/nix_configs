{ config, lib, pkgs, ... }: {
  imports = [
    ./hosts.nix
    ./lan.nix
  ];
}
