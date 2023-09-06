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
      dracula-theme # gtk theme
      firefox-wayland
      foot
      fuzzel # launcher
      gnome44Extensions."gnome-one-window-wonderland@jqno.nl"
      gnome44Extensions."material-shell@papyelgringo"
      gnome44Extensions."quick-settings-audio-panel@rayzeq.github.io"
      gnome.evince
      gnome.gnome-terminal
      gnome.nautilus
      gnomeExtensions.appindicator
      grim # screjnshot functionality
      helvum
      ispell
      mako # notification system developed by swaywm maintainer
      gnvim
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
      swww
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

    i18n.inputMethod.enabled = "ibus";
    i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ mozc hangul libpinyin ];

    sway-gnome.enable = true;

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      emacs = {
        enable = true;
        install = true;
        package = pkgs.emacs29-gtk3;
        defaultEditor = true;
      };

      fwupd.enable = true;

      flatpak.enable = true;

      gnome = {
        core-developer-tools.enable = true;
        games.enable = true;
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

      xserver = {
        enable = true; # even tho this I use wayland.

        desktopManager.gnome.enable = false;

        displayManager.gdm = {
          enable = true;
          autoSuspend = false;
          wayland = true;
        };

        libinput.enable = mkDefault true;
      };

      xfs.enable = false;
    };

    sound.enable = true;

    time.timeZone = null;

    xdg.portal = {
      enable = true;
    };
  };
}
