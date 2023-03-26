{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.desktop;

in {
  options = {
    desktop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  # https://github.com/nix-community/home-manager.git

  config = mkIf cfg.enable {

    boot.kernelPatches = [
      {
        name = "enable RT_FULL";
        patch = null;
        extraConfig = ''
          PREEMPT y
          PREEMPT_BUILD y
          PREEMPT_VOLUNTARY n
          PREEMPT_COUNT y
          PREEMPTION y
        '';
      }
    ];

    environment.systemPackages = with pkgs; [
      alacritty # gpu accelerated terminal
      appimage-run
      bemenu # wayland clone of dmenu
      dracula-theme # gtk theme
      firefox
      foot
      fuzzel # launcher
      glib # gsettings
      gnome.evince
      gnome.gnome-terminal
      gnome.nautilus
      grim # screenshot functionality
      helvum
      mako # notification system developed by swaywm maintainer
      gnvim
      pavucontrol
      slurp # screenshot functionality
      sway
      swayidle
      swaylock
      (
        appimageTools.wrapType2 {
          name = "taskade";
          src = fetchurl {
            url = "https://apps.taskade.com/updates/Taskade_4.2.8_x86_64.AppImage";
            hash = "sha256-6Aj3CemVU3dZb9vLLbyLAS1f81D7jCHCUbXiPI64ytA=";
          };
        }
      )
      waybar
      wayland
      wlogout
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    hardware = {
      opengl = {
        enable = true;
      };
    };

    nixpkgs.config.firefox = {
      enableGnomeExtensions = false;
      enablePlasmaBrowserIntegration = false;
    };

    sway-gnome.enable = true;

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      fwupd.enable = true;

      flatpak.enable = true;

      packagekit.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      printing.enable = true;

      sysprof.enable = true;

      xserver = {
        enable = true; # even tho this I use wayland.

        displayManager.gdm = {
          autoSuspend = false;
          enable = true;
          wayland = true;
        };
      };

      xfs.enable = false;
    };

    sound.enable = true;

    time.timeZone = null;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      gtkUsePortal = true;
    };
  };
}
