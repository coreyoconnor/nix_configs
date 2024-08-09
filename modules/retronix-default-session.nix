{
  config,
  lib,
  retronix,
  ...
}:
with lib; {
  imports = [retronix.nixosModules.default];

  config = mkIf config.retronix.enable {
    networking.firewall = {
      allowedTCPPorts = [8180 9090];
      allowedUDPPorts = [9777];
    };

    programs.steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        capSysNice = true;
      };
      remotePlay.openFirewall = true;
    };

    services = {
      das_watchdog.enable = true;

      displayManager = {
        defaultSession = "steam";

        autoLogin = {
          enable = true;
          user = "media";
        };

        sddm.enable = true;
      };

      libinput.enable = true;
    };
  };
}
