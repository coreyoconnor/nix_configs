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

    nix =
    {
      autoOptimiseStore = true;

      trustedBinaryCaches = [ http://hydra.nixos.org http://agh:5000 ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "agh-1:qqgKseTFXMiOYrm+5LyWz/bKCXahP5KjW1RU6Fph674="
      ];

      trustedUsers = [ "@wheel" ];
    };
  };
}
