{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.desktop;
  # from https://nixos.wiki/wiki/Sway
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };

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
      glib # gsettings
      gnome.evince
      gnome.gnome-terminal
      gnome.nautilus
      grim # screenshot functionality
      helvum
      pavucontrol
      mako # notification system developed by swaywm maintainer
      slurp # screenshot functionality
      sway
      swayidle
      swaylock
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
      enableGnomeExtensions = true;
      enablePlasmaBrowserIntegration = true;
    };

    sway-gnome.enable = true;

    hardware.pulseaudio.enable = false;

    services = {
      automatic-timezoned.enable = true;

      dbus.enable = true;

      fwupd.enable = true;

      flatpak = { enable = true; };

      packagekit.enable = true;

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      sysprof.enable = true;

      xserver = {
        enable = true; # even tho this I use wayland.

        displayManager.gdm = {
          autoSuspend = false;
          enable = true;
          wayland = true;
        };

        # desktopManager.plasma5.enable = true;
      };

      xfs.enable = false;
    };

    sound.enable = true;

    time.timeZone = null;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
    };
  };
}
