{ config, pkgs, lib, ... } :
with lib;
{
  imports = [ ];
  config =
  {
    services.xserver =
    {
      enable = true;
      exportConfiguration = true;
      displayManager.slim =
      {
        enable = true;
      };
    };
  };
}
