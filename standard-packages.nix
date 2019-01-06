{config, pkgs, lib, ...} :
with lib;
let
  overlaysDir = builtins.readDir ./overlays;
  itemNames = attrNames overlaysDir;
  isImportable = f: builtins.match ".*\\.nix" f != null || pathExists (./overlays + ("/" + f + "/default.nix"));
  overlays = map (f: import (./overlays + ("/" + f))) (builtins.filter isImportable itemNames);
in {
  config =
  {
    nixpkgs =
    {
      inherit overlays;
      config = import ./nixpkgs-config.nix;
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
      fonts = with pkgs;
      [
        anonymousPro
        bakoma_ttf
        cm_unicode
        corefonts
        inconsolata
        junicode
        ucsFonts
        unifont
        vistafonts
      ];
    };

    environment.systemPackages = with pkgs;
    [
      acpi
      atk
      autoconf
      automake
      bashInteractive
      coq
      docker
      emacs
      ffmpeg
      fontconfig
      freetype
      fuse
      gcc
      gdb
      gettext
      git
      glib
      glibcLocales
      gnumake
      gnupg
      irssi
      nginx
      nix-index
      ocaml
      openshift
      oprofile
      pkgconfig
      python
      ruby
      screen
      # TODO: move to desktop.nix without breaking existing configs in $HOME
      shared_desktop_ontologies
      shared_mime_info
      stdenv
      utillinuxCurses
      xterm
    ];
  };
}
