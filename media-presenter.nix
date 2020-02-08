{ config, pkgs, lib, ... }:
with lib;
let cfg = config.media-presenter;
in {
  imports = [
    ./dependencies/retronix
    ./users/media.nix
    # TODO: disable musnix for now
    # ./musnix
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

    /* musnix =
       {
         enable = false;
         kernel =
         {
           latencytop = true;
           optimize = true;
           realtime = true;
           # must match computer linuxPackages version
           # packages = pkgs.linuxPackages_4_17_rt;
         };
       };
    */

    networking.firewall = {
      allowedTCPPorts = [ 8180 9090 ];
      allowedUDPPorts = [ 9777 ];
    };

    services = {
      das_watchdog.enable = true;

      xserver = {
        enable = true;
        autorun = true;

        displayManager = {
          defaultSession = "retronix+pekwm";

          lightdm = {
            enable = true;
            autoLogin = {
              enable = true;
              user = "media";
              timeout = 0;
            };
            greeter.enable = false;
          };
        };

        libinput.enable = true;

        windowManager.pekwm.enable = true;
      };
    };

    environment.systemPackages =
      [ pkgs.retroarch ];
  };
}
