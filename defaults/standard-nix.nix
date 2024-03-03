{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    environment = {
      # variables.NIXPKGS_CONFIG = mkForce "${./nixpkgs-config/config.nix}";
    };

    nix = {
      #nixPath = [
      #  "nixos=${nixpkgsSrc}/nixos"
      #  "nixpkgs=${nixpkgsSrc}"
      #  "nixpkgs-overlays=${./nixpkgs-config/overlays}"
      #];

      settings = {
        auto-optimise-store = true;

        experimental-features = ["nix-command" "flakes"];

        substituters = ["http://agh:4999" "http://grr:4999"];
        trusted-users = ["nix" "@wheel"];

        trusted-public-keys = [
          "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
          "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
        ];
      };
    };
  };
}
