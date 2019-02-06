{ config, pkgs, lib, ... } :
with lib;
let
  themes = with pkgs; [
    albatross
    adwaita-qt
    clearlooks-phenix
    elementary-gtk-theme
    gnome3.defaultIconTheme
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
  imports = [ ];
  config =
  {
    environment.systemPackages = with pkgs; gnome3.corePackages ++
    [
      desktop_file_utils
      firefox-devedition-bin
      glib.dev
      gnome3.dconf
      rxvt_unicode
      spectacle
      wine
      winetricks
      xclip
      xdg_utils
    ];

    nixpkgs.config.firefox =
    {
      enableGnomeExtensions = true;
      enablePlasmaBrowserIntegration = true;
    };

    environment.variables =
    {
      GIO_EXTRA_MODULES =
      [
        "${lib.getLib pkgs.gnome3.dconf}/lib/gio/modules"
        "${pkgs.gnome3.glib-networking.out}/lib/gio/modules"
        "${pkgs.gnome3.gvfs}/lib/gio/modules"
      ];
      # workaround libreoffice rending issues.
      SAL_USE_VCLPLUGIN = "gen";

      # missing if plasma5 *only* is enabled?
      GTK_DATA_PREFIX = "${config.system.path}";
      GTK_PATH = [ "${config.system.path}/lib/gtk-3.0" "${config.system.path}/lib/gtk-2.0" ];

      # also missing?
      # The treatment of QT_PLUGIN_PATH is a bit of inconsistent mess in NixOS.
      # search for "qtPluginPrefix" for a perspective
      QT_PLUGIN_PATH =
      [
        "${pkgs.plasma-desktop}/lib/qt-5.11/plugins/kcms"
        "${pkgs.plasma5.plasma-pa}/lib/qt-5.11/plugins/kcms"
      ];
    };

    hardware =
    {
      opengl =
      {
        driSupport32Bit = true;
        enable = true;
        useGLVND = true;
      };
      pulseaudio =
      {
        enable = true;
        package = pkgs.pulseaudioFull;
        support32Bit = true;
        daemon.config =
        {
          flat-volumes = false;
          lock-memory = true;
        };
      };
    };

    services =
    {
      fwupd.enable = true;

      gnome3.chrome-gnome-shell.enable = true;

      flatpak =
      {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-kde ];
      };

      xserver =
      {
        desktopManager.plasma5.enableQt4Support = true;
        # gnome desktop does not work properly without gdm
        displayManager.gdm =
        {
          enable = true;
          wayland = false;
        };
        exportConfiguration = true;
        libinput.enable = true;
        updateDbusEnvironment = true;
      };

      udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
    };

    programs.dconf.enable = true;
    sound.enable = true;
  };
}
