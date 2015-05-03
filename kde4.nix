{ config, pkgs, lib, ... } :
with lib;
{
  nixpkgs.config.packageOverrides = pkgs :
  {
    kde4 = pkgs.kde414;
    freetype = import (pkgs.path + "/pkgs/development/libraries/freetype") {
        inherit (pkgs) stdenv fetchurl gnumake fetchpatch pkgconfig which zlib bzip2 libpng glib;
        useEncumberedCode = true;
    };
  };

  environment.systemPackages = 
  [ 
    pkgs.kde4.kactivities # Required. Otherwise KDE Activities do not work.
    pkgs.kde4.okular
    pkgs.popplerQt4
    pkgs.poppler_data
    pkgs.kde4.kdeartwork.styles
    pkgs.kde4.kdeartwork.kwin_styles
    pkgs.oxygen_gtk # So GTK apps look like Oxygen. TODO: Using gtk-kde4 would be better.
    pkgs.kde4.kdebindings.pykde4
    pkgs.kde4.kdebindings.smokekde
    pkgs.kde4.kdebindings.qtruby
    pkgs.kde4.kdeplasma_addons
  ];

  services.xserver.displayManager.kdm.enable = true;
}

