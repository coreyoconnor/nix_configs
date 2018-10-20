{ config, lib, pkgs, pkgs_i686, ... }:

{
  imports =
  [
    ./common-configuration.nix
    ../../desktop.nix
  ];

  config =
  {
    hardware =
    {
      opengl =
      {
        extraPackages = [ pkgs.mesa_drivers ];
        extraPackages32 = [ pkgs_i686.mesa_drivers ];
      };

      pulseaudio =
      {
        configFile = ./pulse-audio-config.pa;
        daemon.config =
        {
          default-sample-rate = 96000;
          default-sample-format = "s24le";
          avoid-resampling = true;
        };
      };
    };

    services.xserver =
    {
      enable = true;
      desktopManager =
      {
        default = "gnome3";
        gnome3.enable = true;
        plasma5.enable = true;
      };

      videoDrivers = [ "nvidia" ];

      deviceSection = ''
        BusID "PCI:05:00:00"
      '';

      xrandrHeads =
      [
        {
            output = "DVI-I-1-1";
            monitorConfig = ''
            Option "PreferredMode" "2560x1080"
            '';
            primary = true;
        }
      ];

      inputClassSections =
      [ ''
        Identifier "joystick catchall"
        MatchIsJoystick "on"
        MatchDevicePath "/dev/input/event*"
        Driver "joystick"
        Option "StartKeysEnabled" "False"
        Option "StartMouseEnabled" "False"
      '' ];

      screenSection = ''
        Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
      '';
    };
  };
}
