{config, pkgs, ...}:
{
  require =
  [
    ./dependencies/retronix
    ./users/media.nix
    ./musnix
  ];

  retronix =
  {
    enable = true;
    user = "media";
  };

  musnix =
  {
    enable = false;
    kernel =
    {
      latencytop = true;
      optimize = true;
      realtime = true;
      # must match computer linuxPackages version
      packages = pkgs.linuxPackages_4_9_rt;
    };
  };

  networking.firewall =
  {
    allowedTCPPorts = [ 8180 9090 ];
    allowedUDPPorts = [ 9777 ];
  };

  services.xserver.displayManager.slim =
  {
    enable = true;
    defaultUser = "media";
    autoLogin = true;
  };

  #services.xserver.desktopManager.kodi.enable = true;
  #services.xserver.desktopManager.default = "kodi";
  services.xserver.desktopManager.default = "retroarch";

  services.xserver.desktopManager.session = [{
    name = "retroarch";
    start = ''
      ${pkgs.retroarch}/bin/retroarch &
      waitPID=$!
    '';
  }];
  services.xserver.windowManager.pekwm.enable = true;
  services.xserver.windowManager.default = "pekwm";
}
