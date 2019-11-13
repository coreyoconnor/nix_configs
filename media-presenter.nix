{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.media-presenter;
in {
  imports =
  [
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
    retronix =
    {
      enable = true;
      user = "media";
    };

    nixpkgs.config =
    {
      kodi =
      {
        enableSteamLauncher = true;
        enableAdvancedLauncher = true;
        enableAdvancedEmulatorLauncher = true;
        # enableControllers = true;
        enableControllers = false;
        enableJoystick = true;
      };
    };

  /*
    musnix =
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

    networking.firewall =
    {
      allowedTCPPorts = [ 8180 9090 ];
      allowedUDPPorts = [ 9777 ];
    };

    services.xserver = {
      enable = true;
      autostart = true;

      displayManager = {
        slim = {
          enable = true;
          defaultUser = "media";
          autoLogin = true;
        };
      };

      desktopManager = {
        kodi.enable = true;
        # default = "kodi";
        default = "retronix";
      };

      libinput.enable = true;

      windowManager.pekwm.enable = true;
      windowManager.default = "pekwm";
    };

    environment.systemPackages = [
      pkgs.kodi
      pkgs.kodi-retroarch-advanced-launchers
      pkgs.retroarch
    ];
  };
}
