{ config, pkgs, lib, ... } :
with lib;
{
  imports = [ ];
  config =
  {
    environment.systemPackages = with pkgs; gnome3.corePackages ++
    [
      desktop_file_utils
      gnome3.defaultIconTheme
      firefox-devedition-bin
      hicolor-icon-theme
      xcompmgr
      xlibs.fontutil
      xlibs.kbproto
      xlibs.libICE
      xlibs.libXt
      xlibs.libXtst
      xlibs.libXaw
      xlibs.xproto
      xlibs.xinput
      xclip
      xdg_utils
      rxvt_unicode
      spectacle
      gnome3.dconf
      wine
      winetricks
    ];

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
      flatpak =
      {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-kde ];
      };
      xserver =
      {
        desktopManager.plasma5.enableQt4Support = true;
        displayManager.slim.enable = true;
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
