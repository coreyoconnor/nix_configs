{ config, pkgs, ... } :

with pkgs.lib;

{
  config =
  {
    environment.systemPackages =
      [ pkgs.maven3
        pkgs.jdk
        # pkgs.eclipses.eclipse_sdk_42
      ];
  };
}
