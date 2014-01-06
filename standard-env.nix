{config,pkgs,...}:
with pkgs.lib;
{
  config =
  {
    environment.pathsToLink =
    [ 
      "/share"
      "/etc/gconf"
    ];

    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
      export LC_ALL=${config.i18n.defaultLocale}
    '';

    time.timeZone = "America/Los_Angeles";

    security.sudo.enable = true;
    security.sudo.configFile = ''
      Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
      Defaults:root,%wheel env_keep+=NIX_PATH
      Defaults:root,%wheel env_keep+=TERMINFO_DIRS

      root        ALL=(ALL) SETENV: ALL
      %wheel      ALL=(ALL) NOPASSWD: SETENV: ALL
    '';
  };
}
