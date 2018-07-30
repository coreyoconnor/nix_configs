{config, pkgs, lib, ...} :
with lib;
{
  config =
  {
    nixpkgs =
    {
      overlays = [ (import ./overlays/standard.nix) ];
      config =
      {
        allowBroken = true;
      };
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
      enableDefaultFonts = true;
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

    environment.systemPackages = with pkgs;
    [
      stdenv
      atk
      autoconf
      automake
      bashInteractive
      gdb
      glibcLocales
      screen
      utillinuxCurses
      git
      acpi
      ruby
      gcc
      coq
      oprofile
      ffmpeg
      freetype
      fuse
      gettext
      glib
      gnumake
      gnupg
      inconsolata
      nginx
      ocaml
      perlXMLParser
      pkgconfig
      python
      emacs
      vpnc
      xterm
      irssi
      shared_mime_info
      taskwarrior
      # TODO: move to desktop.nix without breaking existing configs in $HOME
      shared_desktop_ontologies
      fontconfig
    ];
  };
}
