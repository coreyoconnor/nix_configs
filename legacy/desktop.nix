{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  themes = with pkgs; [
    albatross
    adwaita-qt
    breeze-gtk
    breeze-icons
    breeze-qt5
    clearlooks-phenix
    elementary-gtk-theme
    gnome3.defaultIconTheme
    gnome-breeze
    gnome-themes-extra
    hicolor-icon-theme
    materia-theme
    material-icons
    onestepback
    nordic
    nordic-polar
    qtcurve
    theme-obsidian2
    theme-vertex
  ];
in {
  imports = [./base.nix ./fonts.nix];

  config = {
    environment.systemPackages = with pkgs; [
      appimage-run
      desktop-file-utils
      firefox-devedition-bin
      glib.dev
      dconf
      home-manager
      qt5.qtbase
      rxvt_unicode
      spectacle
      wine
      winetricks
      xclip
      xdg_utils
    ];

    environment.variables = {
      # workaround libreoffice rending issues.
      SAL_USE_VCLPLUGIN = "gen";

      # missing if plasma5 *only* is enabled?
      GTK_DATA_PREFIX = "${config.system.path}";
      GTK_PATH = [
        "${config.system.path}/lib/gtk-3.0"
        "${config.system.path}/lib/gtk-2.0"
      ];
    };

    hardware = {
      opengl = {
        enable = true;
      };
      pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
        daemon.config = {
          flat-volumes = false;
          lock-memory = true;
        };
      };
    };

    nixpkgs.config.firefox = {
      enableGnomeExtensions = true;
      enablePlasmaBrowserIntegration = true;
    };

    programs.dconf.enable = true;

    services = {
      fwupd.enable = true;

      gnome = {
        chrome-gnome-shell.enable = true;
        core-shell.enable = true;
      };

      flatpak = {enable = true;};

      packagekit.enable = true;

      xserver = {
        exportConfiguration = true;
        libinput.enable = true;
        updateDbusEnvironment = true;
      };

      udev.packages = [pkgs.gnome3.gnome-settings-daemon];
      sysprof.enable = true;
    };

    sound.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-kde];

    services.xfs.enable = false;
  };
}
