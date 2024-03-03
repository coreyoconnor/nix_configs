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

      xserver = {
        autorun = true;

        displayManager = {
          defaultSession = "retronix+pekwm";

          autoLogin = {
            enable = true;
            user = "media";
          };

          lightdm = {
            enable = true;
            greeter.enable = false;
            autoLogin = {
              timeout = 0;
            };
          };
        };

        libinput.enable = true;

        windowManager.pekwm.enable = true;
      };
    };
  };
}
