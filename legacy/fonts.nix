{ config, pkgs, lib, ... }:
with lib; {
  config = {
    fonts = {
      fontconfig = {
        enable = true;
        allowBitmaps = false;
      };
      fontDir.enable = true;
      enableDefaultFonts = true;
      fonts = with pkgs; [
        anonymousPro
        bakoma_ttf
        cm_unicode
        corefonts
        inconsolata
        junicode
        ucs-fonts
        unifont
        # vistafonts
      ];
    };
  };
}
