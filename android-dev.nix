{ config, pkgs, lib, ... } :
let androidsdk = pkgs.androidenv.androidsdk_5_0_1_extras; in
{
  config =
  {
    environment.shellInit = ''
      export ANDROID_HOME=${androidsdk}
    '';

    environment.systemPackages =
      [ pkgs.jdk
        androidsdk
      ];
  };
}
