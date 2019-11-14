{ config, pkgs, lib, ... }:
with lib; rec {
  imports = [ ./nixpkgs-config.nix ./foreign-binary-emulation.nix ];

  options = { };

  config = { services.foreign-binary-emulation.enable = true; };
}
