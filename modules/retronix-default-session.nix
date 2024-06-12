{
  config,
  lib,
  retronix,
  ...
}:
with lib; {
  imports = [retronix.nixosModules.default];

  config = mkIf config.retronix.enable {
    hardware.pulseaudio = {
      extraClientConf = ''
        autospawn=yes
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [8180 9090];
      allowedUDPPorts = [9777];
    };

    services = {
      das_watchdog.enable = true;

      displayManager = {
        defaultSession = "retronix+pekwm";

        autoLogin = {
          enable = true;
          user = "media";
        };
      };

      libinput.enable = true;

      xserver = {
        autorun = true;

        displayManager = {

          lightdm = {
            enable = true;
            greeter.enable = false;
            autoLogin = {
              timeout = 0;
            };
          };
        };

        windowManager.pekwm.enable = true;
      };
    };
  };
}
