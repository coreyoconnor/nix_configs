{ config, pkgs, ... } :
with pkgs.lib;
{
  options =
  {
    environment.useInfinality = mkOption
    {
      default = true;
      example = true;
      type = with types; bool;
      description = ''
          Use infinality patches on freetyp
      '';
    };
  };

  config =
  {
    nixpkgs.config.packageOverrides = pkgs : 
    { 
      kde4 = pkgs.kde412;
      freetype = import (pkgs.path + "/pkgs/development/libraries/freetype") {
          inherit (pkgs) stdenv fetchurl gnumake;
          useInfinality = config.environment.useInfinality;
      };
    };

    environment.systemPackages = 
    [ 
      # pkgs.kde4.calligra
      pkgs.kde4.kactivities # Required. Otherwise KDE Activities do not work.
      pkgs.kde4.kdelibs
      pkgs.kde4.kde_runtime
      pkgs.kde4.okular
      pkgs.popplerQt4
      pkgs.poppler_data
      pkgs.kde4.oxygen_icons
      # pkgs.kde4.kdeartwork.aurorae
      pkgs.kde4.kdeartwork.styles
      pkgs.kde4.kdeartwork.kwin_styles
      pkgs.oxygen_gtk # So GTK apps look like Oxygen. TODO: Using gtk-kde4 would be better.
    ];

    services.xserver.displayManager.kdm.enable = true;
  };
}

