{ config, pkgs, lib, ... }:
with lib;
let cfg = config.desktop;
in {
  options = {
    desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      home-manager
      appimage-run
    ];

    hardware = {
      opengl = {
        enable = true;
      };

      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
        daemon.config = {
          default-sample-rate = "48000";
          high-priority = "yes";
          realtime-scheduling = "yes";
          realtime-priority = "9";
          log-level = "debug";
          avoid-resampling = "yes";
          flat-volumes = "yes";
        };
      };
    };

    nixpkgs.config.firefox = {
      enableGnomeExtensions = true;
      enablePlasmaBrowserIntegration = true;
    };

    services = {
      automatic-timezoned.enable = true;

      fwupd.enable = true;

      flatpak = { enable = true; };

      packagekit.enable = true;

      sysprof.enable = true;

      xfs.enable = false;
    };

    sound.enable = true;

    time.timeZone = null;
  };
}
