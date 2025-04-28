{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
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

  imports = [
    ../hardware/desktop-devices.nix
  ];

  config = mkIf cfg.enable {
    semi-active-av.enable = true;

    #boot.kernelPatches = [
    #  {
    #    name = "enable RT_FULL";
    #    patch = null;
    #    extraConfig = ''
    #      PREEMPT y
    #      PREEMPT_BUILD y
    #      PREEMPT_VOLUNTARY n
    #      PREEMPT_COUNT y
    #      PREEMPTION y
    #    '';
    #  }
    #];

    environment.systemPackages = with pkgs; [
      appimage-run
      brightnessctl
      dracula-theme # gtk theme
      firefox-wayland
      foot
      fuzzel # launcher
      evince
      gnome-terminal
      nautilus
      gnomeExtensions.appindicator
      grim # screjnshot functionality
      keybase-gui
      keyd # key remapping
      helvum
      ispell
      mako # notification system developed by swaywm maintainer
      neovim-qt
      nordpass
      clinfo
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
      vulkan-tools
      waybar
      wayland
      wine
      wine64Forwarder
      winetricks
      wlogout
      wluma # brightness control
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    ];

    hardware = {
      graphics = {
        enable = true;
      };
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [ fcitx5-rime ];
        waylandFrontend = true;
      };
    };

    sway-gnome.enable = true;

    hardware.pulseaudio.enable = false;

    programs.dconf.profiles.gdm.databases = [{
      settings."org/gnome/login-screen" = {
        enable-fingerprint-authentication = false;
      };
    }];

    security.rtkit.enable = true;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      flatpak.enable = true;

      gnome = {
        core-developer-tools.enable = true;
        games.enable = true;
      };

      keyd = {
        enable = true;
        keyboards = {
          default = {
            ids = ["*"];
            settings = {
              main = {
                capslock = "overload(capslock, esc)";
              };
              "capslock:C" = {};
            };
          };
        };
      };

      kubo = {
        enable = true;
      };

      libinput.enable = mkDefault true;

      packagekit.enable = false;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      printing.enable = true;

      samba-wsdd.enable = true;

      sysprof.enable = true;

      udev.packages = [pkgs.android-udev-rules];

      xserver.enable = true; # for xwayland

      xserver.displayManager.gdm = {
        enable = true;
        debug = true;
        autoSuspend = false;
        wayland = true;
      };

      xfs.enable = false;
    };

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
