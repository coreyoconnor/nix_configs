{ config, lib, pkgs, modulesPath, ... }:
with lib;
let cfg = config.retronix;
in {
  imports = [ ../dependencies/retronix ];

  config = mkIf cfg.enable {
    hardware.pulseaudio = {
      extraClientConf = ''
        autospawn=yes
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [ 8180 9090 ];
      allowedUDPPorts = [ 9777 ];
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

    environment.systemPackages = [ pkgs.glxinfo ];
  };
}
