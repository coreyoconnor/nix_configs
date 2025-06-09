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
      rt = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  imports = [
    ../hardware/desktop-devices.nix
  ];

  config = mkIf cfg.enable {
    semi-active-av.enable = true;

    boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_14.override {
      structuredExtraConfig = with lib.kernel; {
          PREEMPT = lib.mkForce yes;
          PREEMPT_RT = if cfg.rt then yes else no;
          PREEMPT_COUNT = yes;
          CONFIG_MK8 = yes;
          CONFIG_GENERIC_CPU = unset;
          CONFIG_X86_INTEL_USERCOPY = yes;
          CONFIG_X86_USE_PPRO_CHECKSUM = yes;
      };
      ignoreConfigErrors = true;
    });

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
        alsa = {
          enable = true;
          support32Bit = true;
        };
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
