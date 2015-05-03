{config, pkgs, lib, ...}:
with lib;
{
  config =
  {
    environment.pathsToLink =
    [ 
      "/share"
      "/etc/gconf"
    ];

    environment.shellInit = ''
      export LC_ALL=${config.i18n.defaultLocale}
    '';

    time.timeZone = "America/Los_Angeles";

    security.sudo.enable = true;
    security.sudo.wheelNeedsPassword = false;

    security.sudo.configFile = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS
    '';

    users.mutableUsers = true;
    nixpkgs.config.allowUnfree = true;
  };
}
