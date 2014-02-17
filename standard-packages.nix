{config, pkgs, ...} :
with pkgs.lib;
{
  config =
  {
    # nixpkgs.config.chromium.channel = "dev";

    fonts =
    {
      enableFontDir = true;
      extraFonts = 
      [
        pkgs.anonymousPro
        pkgs.arkpandora_ttf
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
      pkgs.cairo
      pkgs.gdb
      pkgs.gdk_pixbuf
      pkgs.glibcLocales
      pkgs.screen
      pkgs.utillinuxCurses
      pkgs.gitSVN
      pkgs.acpi
      pkgs.ruby19
      pkgs.rubySqlite3
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
      # pkgs.isabelle
      pkgs.maven3
      pkgs.jdk
      pkgs.jre
      pkgs.nginx
      pkgs.ocaml
      pkgs.perlXMLParser
      pkgs.pkgconfig
      pkgs.python
      pkgs.emacs
      pkgs.qemu
      pkgs.vala
      pkgs.vpnc
      pkgs.xterm
      pkgs.desktop_file_utils
      pkgs.evince
      pkgs.flashplayer
      pkgs.gnome.GConf
      pkgs.gnome.gtk
      # pkgs.gnome.intltool
      pkgs.gnome.gtk_doc
      pkgs.gnome.gnomeicontheme
      pkgs.gnome.pango
      pkgs.gnome.vte
      pkgs.gtkLibs.gtk # To get GTK+'s themes.
      pkgs.shared_mime_info
      pkgs.shared_desktop_ontologies
      # pkgs.swt
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
