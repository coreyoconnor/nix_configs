{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    nix = {
      settings = {
        auto-optimise-store = true;

        experimental-features = ["nix-command" "flakes"];

        substituters = ["http://ufo:4999" "https://cache.nixos.org"];
        trusted-users = ["nix" "@wheel"];

        trusted-public-keys = [
          "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
          "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
          "ufo-1:xVu3KxBuyYSZnnqqZjDNFok7KQJtiDJHeshM84OJjXY="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
      };
    };
  };
}
