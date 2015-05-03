{ config, pkgs, ... } :

{
  config =
  {
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages =
      [ pkgs.maven3
        pkgs.jdk
      ];
  };
}
