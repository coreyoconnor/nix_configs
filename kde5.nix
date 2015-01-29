{ config, pkgs, ... } :
with pkgs.lib;
{
  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.displayManager.kdm.enable = true;
}

