{ config, lib, pkgs, ... }:

{
  imports = [ ./common-configuration.nix ];

  config = {
    hardware = {
      pulseaudio = {
        configFile = ./pulse-audio-config.pa;
        daemon.config = {
          default-sample-rate = 96000;
          default-sample-format = "s24le";
          avoid-resampling = true;
        };
      };

    };

    nixpkgs = { config = { cudaSupport = true; }; };

    services.xserver = {
      enable = false;

      desktopManager = {
        gnome.enable = true;
        plasma5.enable = false;
      };

      videoDrivers = [ "nvidia" ];

      deviceSection = ''
        BusID "PCI:05:00:00"
      '';

      xrandrHeads = [{
        output = "DVI-I-1-1";
        monitorConfig = ''
          Option "PreferredMode" "2560x1080"
        '';
        primary = true;
      }];

      inputClassSections = [''
        Identifier "joystick catchall"
        MatchIsJoystick "on"
        MatchDevicePath "/dev/input/event*"
        Driver "joystick"
        Option "StartKeysEnabled" "False"
        Option "StartMouseEnabled" "False"
      ''];

      screenSection = ''
        Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
      '';
    };

    time.timeZone = "UTC";
  };
}
