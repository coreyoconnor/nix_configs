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
        arphic-ukai
        arphic-uming
        bakoma_ttf
        cm_unicode
        corefonts
        font-awesome
        hack-font
        inconsolata
        junicode
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji
        noto-fonts-emoji-blob-bin
        noto-fonts-extra
        ucs-fonts
        unifont
        # vistafonts
        wqy_microhei
        wqy_zenhei
      ];
    };
  };
}
