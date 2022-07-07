{ config, pkgs, lib, ... }:
with lib; rec {
  imports = [
    ./nixpkgs-config.nix
    ./foreign-binary-emulation.nix
    ./standard-admin.nix
    ./standard-env.nix
    ./standard-services.nix
  ];

  options = { };

  config = { services.foreign-binary-emulation.enable = true; };
}
