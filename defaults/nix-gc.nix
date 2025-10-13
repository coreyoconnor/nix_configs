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
          automatic = true;
          options = "--delete-older-than 30d";
        };

        optimise.automatic = true;

        settings = {
          auto-optimise-store = true;
        };

        # Opinionated: gc is overly aggressive
        gc.dates = "weekly";
      };

      systemd.tmpfiles.rules = ["R /tmp/nix* - - - 60d" "R! /tmp/* - - - 6m"];
    };
  }
