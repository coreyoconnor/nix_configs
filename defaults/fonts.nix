{ config, pkgs, lib, ... }:
with lib; {
  config = mkIf config.default.graphical {
    boot.loader.grub = {
      fontSize = 24;
    };

    console = {
      font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-i24n.psf.gz";
      packages = [ pkgs.terminus_font ];
    };

    fonts = {
      fontconfig = {
        enable = true;
        allowBitmaps = false;
      };

      fontDir.enable = true;

      enableDefaultPackages = true;

      packages = with pkgs; [
        anonymousPro
        arphic-ukai
        arphic-uming
        atkinson-hyperlegible
        bakoma_ttf
        borg-sans-mono
        cm_unicode
        corefonts
        dejavu_fonts
        fira-code
        fira-code-symbols
        fira-mono
        font-awesome
        google-fonts
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
