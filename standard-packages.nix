{config, pkgs, lib, ...} :
with lib;
{
  config =
  {
    nixpkgs.config.chromium =
    {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };

    fonts =
    {
      fontconfig.enable = true;
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

    environment.etc."fonts/conf.d/80-no-bitmaps.conf".text =
      ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <!-- /etc/fonts/conf.d/no-bitmaps.conf -->
        <fontconfig>
          <!-- Reject bitmap fonts -->
          <selectfont>
            <rejectfont>
              <pattern>
                <patelt name="scalable"><bool>false</bool></patelt>
              </pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';

    environment.systemPackages =
    [
      pkgs.stdenv
      pkgs.atk
      pkgs.ant
      pkgs.autoconf
      pkgs.automake
      pkgs.bashInteractive
      # pkgs.bitcoin
      pkgs.cairo
      pkgs.chromium
      pkgs.gdb
      pkgs.gdk_pixbuf
      pkgs.glibcLocales
      pkgs.screen
      pkgs.utillinuxCurses
      pkgs.gitSVN
      pkgs.acpi
      pkgs.ruby_2_1
      # pkgs.rubygems
      # pkgs.rubySqlite3
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
      pkgs.nginx
      pkgs.ocaml
      pkgs.perlXMLParser
      pkgs.pkgconfig
      pkgs.python
      pkgs.emacs
      pkgs.qemu
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
      pkgs.irssi
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
      pkgs.wireshark
      pkgs.wineUnstable
    ];

    security.setuidOwners = [
    {
      program = "dumpcap";
      owner = "root";
      group = "wheel";
      setuid = true;
      setgid = false;
      permissions = "u+rx,g+x";
    }];
  };
}
