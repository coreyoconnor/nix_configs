{ config, pkgs, lib, ... }:
with lib; {
  config = mkIf config.default.graphical {
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
        font-awesome
        hack-font
        inconsolata
        junicode
        ucs-fonts
        unifont
        # vistafonts
      ];
    };
  };
}
