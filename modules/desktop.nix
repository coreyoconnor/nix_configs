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

  config = mkIf cfg.enable {
    semi-active-av.enable = true;

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
      appimage-run
      brightnessctl
      dracula-theme # gtk theme
      firefox-wayland
      foot
      fuzzel # launcher
      gnome.evince
      gnome.gnome-terminal
      gnome.nautilus
      gnomeExtensions.appindicator
      grim # screjnshot functionality
      keyd # key remapping
      helvum
      ispell
      mako # notification system developed by swaywm maintainer
      neovim-qt
      nordpass
      pavucontrol
      qt6Packages.qtwayland
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
      swww # wallpaper
      waybar
      wayland
      wlogout
      wluma # brightness control
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    hardware = {
      opengl = {
        enable = true;
      };
    };

    i18n.inputMethod.enabled = "ibus";
    i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ mozc hangul libpinyin ];

    sway-gnome.enable = true;

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      fwupd.enable = true;

      flatpak.enable = true;

      gnome = {
        core-developer-tools.enable = true;
        games.enable = true;
      };

      keyd = {
        enable = true;
        settings = {
          main = {
            capslock = "overload(capslock, esc)";
          };
          "capslock:C" = {};
        };
      };

      packagekit.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      printing.enable = true;

      sysprof.enable = true;

      udev.packages = [ pkgs.android-udev-rules ];

      xserver = {
        enable = true; # even tho this I use wayland.

        desktopManager.gnome.enable = false;

        displayManager.gdm = {
          enable = true;
          debug = true;
          autoSuspend = false;
          wayland = true;
        };

        libinput.enable = mkDefault true;
      };

      xfs.enable = false;
    };

    sound.enable = true;

    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';

    time.timeZone = null;

    xdg.mime.enable = true;

    xdg.portal = {
      enable = true;
    };
  };
}
