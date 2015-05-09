{ config, pkgs, ... } :

{
  config =
  {
    # TODO: Just using pkgs.jdk with icedtea will point to a directory without
    # a proper lib directory. EG: tools.jar is missing.
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}/lib/icedtea
    '';

    environment.systemPackages =
      [ pkgs.maven3
        pkgs.jdk
      ];
  };
}
