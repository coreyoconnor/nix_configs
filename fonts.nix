{ config, pkgs, lib, ... }:
with lib; {
  config = {
    fonts = {
      fontconfig = {
        enable = true;
        allowBitmaps = false;
      };
      enableFontDir = true;
      enableDefaultFonts = true;
      fonts = with pkgs; [
        anonymousPro
        bakoma_ttf
        cm_unicode
        corefonts
        inconsolata
        junicode
        ucsFonts
        unifont
        # vistafonts
      ];
    };
  };
}
