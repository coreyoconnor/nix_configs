{ config, pkgs, ... } :

with pkgs.lib;

{
  config =
  {
    environment.shellInit = ''
      export ANDROID_HOME=${pkgs.androidsdk_4_4}
    '';

    environment.systemPackages =
      [ pkgs.jdk
        pkgs.androidsdk_4_4
      ];
  };
}
