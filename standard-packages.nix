{config, pkgs, lib, ...} :
with lib;
{
  config =
  {
    nixpkgs.config =
    {
      allowBroken = true;
      /*
      chromium =
      {
        enablePepperFlash = true;
        enablePepperPDF = true;
      };
      */
    };

    fonts =
    {
      fontconfig =
      {
        enable = true;
        allowBitmaps = false;
        ultimate =
        {
          enable = true;
        };
      };
      enableFontDir = true;
      fonts =
      [
        pkgs.anonymousPro
        pkgs.bakoma_ttf
        pkgs.corefonts
        pkgs.cm_unicode
        pkgs.junicode
        pkgs.ucsFonts
        pkgs.unifont
        pkgs.vistafonts
      ];
    };

    environment.systemPackages =
    [
      pkgs.stdenv
      pkgs.atk
      pkgs.ant
      pkgs.autoconf
      pkgs.automake
      pkgs.bashInteractive
      # pkgs.cairo
      pkgs.gdb
      # pkgs.gdk_pixbuf
      pkgs.glibcLocales
      pkgs.screen
      pkgs.utillinuxCurses
      pkgs.git
      pkgs.acpi
      pkgs.ruby_2_1
      pkgs.gcc
      pkgs.coq
      pkgs.oprofile
      pkgs.ffmpeg
      pkgs.freetype
      pkgs.fuse
      pkgs.gettext
      pkgs.glib
      pkgs.gnumake
      pkgs.gnupg
      pkgs.inconsolata
      pkgs.nginx
      pkgs.ocaml
      pkgs.perlXMLParser
      pkgs.pkgconfig
      pkgs.python
      pkgs.emacs
      pkgs.vpnc
      pkgs.xterm
      pkgs.desktop_file_utils
      # pkgs.evince
      # pkgs.gnome3.gconf
      # pkgs.gtk3
      # pkgs.gtk_doc
      # pkgs.gnome3.defaultIconTheme
      # pkgs.pango
      # pkgs.gnome3.vte
      pkgs.irssi
      pkgs.shared_mime_info
      pkgs.shared_desktop_ontologies
      pkgs.taskwarrior
      pkgs.xcompmgr
      pkgs.xlibs.fontutil
      pkgs.xlibs.kbproto
      pkgs.xlibs.libICE
      pkgs.xlibs.libXt
      pkgs.xlibs.libXtst
      pkgs.xlibs.libXaw
      pkgs.xlibs.xproto
      pkgs.xlibs.xinput
      pkgs.fontconfig
      pkgs.hicolor_icon_theme
      pkgs.xclip
      pkgs.xdg_utils
      pkgs.rxvt_unicode
    ];
  };
}
