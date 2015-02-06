{ config, pkgs, ... } :
with pkgs.lib;
{
  services.xserver.desktopManager.kde5 =
  {
    enable = true;
    phononBackends = [ "vlc" ];
  };
  services.xserver.displayManager.kdm.enable = true;
  nixpkgs.config.packageOverrides = in_pkgs : rec
  {
      kf5_stable = in_pkgs.kf56;
      plasma5_stable = in_pkgs.plasma52;
      kdeApps_stable = in_pkgs.kdeApps_14_12;
  };
}

