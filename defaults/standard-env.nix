{ config, pkgs, lib, ... }:
with lib;
let nixpkgsSrc = ../nixpkgs;
in {
  config = {
    environment = {
      pathsToLink = [ "/share" "/etc/gconf" ];

      shellInit = ''
        export LC_ALL=${config.i18n.defaultLocale}
      '';

      variables.NIXPKGS_CONFIG = mkForce "${./nixpkgs-config/config.nix}";
    };

    security.sudo.enable = true;
    security.sudo.wheelNeedsPassword = false;

    security.sudo.configFile = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    '';

    nix = {
      nixPath = [
        "nixos=${nixpkgsSrc}/nixos"
        "nixpkgs=${nixpkgsSrc}"
        "nixpkgs-overlays=${./nixpkgs-config/overlays}"
      ];

      settings = {
        auto-optimise-store = true;

        experimental-features = [ "nix-command" "flakes" ];

        substituters = [ "http://agh:4999" "http://grr:4999" ];
        trusted-users = [ "nix" "@wheel" ];

        trusted-public-keys = [
          "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
          "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
        ];
      };
    };
  };
}
