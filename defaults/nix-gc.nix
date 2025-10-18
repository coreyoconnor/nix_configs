{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
  with lib; {
    config = {
      nix = {
        gc = {
          automatic = mkDefault true;
          options = "--delete-older-than 30d";
        };

        optimise.automatic = mkDefault true;

        settings = {
          auto-optimise-store = mkDefault true;
        };

        # Opinionated: gc is overly aggressive
        gc.dates = mkDefault "weekly";
      };

      systemd.tmpfiles.rules = ["R /tmp/nix* - - - 60d" "R! /tmp/* - - - 6m"];
    };
  }
