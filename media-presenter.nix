{config, pkgs, ...}:
{
  require =
  [
    ./users/media.nix
  ];

  services.xserver.displayManager.slim =
  {
    enable = true;
    defaultUser = "media";
    autoLogin = true;
  };

  services.xserver.desktopManager.xbmc.enable = true;
}
