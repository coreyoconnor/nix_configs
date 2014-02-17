{ config, pkgs, ... } :

with pkgs.lib;

{
  config =
  {
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages =
      [ pkgs.maven3
        pkgs.jdk
        # pkgs.eclipses.eclipse_sdk_42
      ];
  };
}
