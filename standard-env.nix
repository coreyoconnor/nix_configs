{ config, pkgs, lib, ... }:
with lib; {
  config = {
    environment.pathsToLink = [ "/share" "/etc/gconf" ];

    environment.shellInit = ''
      export LC_ALL=${config.i18n.defaultLocale}
    '';

    security.sudo.enable = true;
    security.sudo.wheelNeedsPassword = false;

    security.sudo.configFile = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    '';

    nix = {
      autoOptimiseStore = true;

      binaryCaches = [ "http://agh:4999" ];
      binaryCachePublicKeys = [
        "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
        "grr-1:YxoRaiS/IfOtt/DaNvU8xJ0BXxYI8poimtPhlWIWBAU="
      ];

      trustedUsers = [ "nix" "@wheel" ];

      extraOptions = ''
        keep-outputs = true
      '';
    };
  };
}
