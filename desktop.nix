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
      gnome3.dconf
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
      # build broken?
      # flatpak.enable = true;
      xserver =
      {
        desktopManager.plasma5.enableQt4Support = true;
        exportConfiguration = true;
        displayManager.slim.enable = true;
        updateDbusEnvironment = true;
      };
    };

    sound.enable = true;
  };
}
