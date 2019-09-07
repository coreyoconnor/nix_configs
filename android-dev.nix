{ config, pkgs, lib, ... } :
let androidsdk = pkgs.androidenv.androidsdk_9_0; in
{
  options = {
  };

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
