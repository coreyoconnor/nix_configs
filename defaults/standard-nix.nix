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
        settings = {
          auto-optimise-store = true;

          experimental-features = ["nix-command" "flakes"];

          substituters = ["http://ufo:4999"];
          trusted-users = ["nix" "@wheel"];

          trusted-public-keys = [
            "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
            "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
            "ufo-1:xVu3KxBuyYSZnnqqZjDNFok7KQJtiDJHeshM84OJjXY="
          ];

          flake-registry = "";
          # Workaround for https://github.com/NixOS/nix/issues/9574
          nix-path = config.nix.nixPath;
        };

        # Opinionated: disable channels
        channel.enable = false;

        # Opinionated: make flake registry and nix path match flake inputs
        registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
        nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

        # gc is overly aggressive
        gc.dates = "weekly";
      };
    };
  }
