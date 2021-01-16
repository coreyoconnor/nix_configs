{ config, pkgs, lib, ... }:
with lib;
let cfg = config.media-presenter;
in {
  imports = [
    ./dependencies/retronix
  ];

  options = {
    media-presenter = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    retronix = {
      enable = true;
      user = "media";
    };
    hardware.pulseaudio = {
      # enable = false;
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

    environment.systemPackages =
      [ pkgs.retroarch pkgs.glxinfo ];
  };
}
