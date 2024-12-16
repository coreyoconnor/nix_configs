{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config =
    {
      boot.loader.grub = {
        fontSize = 24;
      };

      console = {
        font = mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-i24n.psf.gz";
        packages = [pkgs.terminus_font];
      };
    }
    // mkIf config.default.graphical {
      fonts = {
        fontconfig = {
          enable = true;
          allowBitmaps = false;
        };

        fontDir.enable = true;

        enableDefaultPackages = true;

        packages = with pkgs; [
          anonymousPro
          atkinson-hyperlegible
          bakoma_ttf
          borg-sans-mono
          cm_unicode
          corefonts
          courier-prime
          dejavu_fonts
          fira-mono
          # google-fonts
          helvetica-neue-lt-std
          inconsolata
          junicode
          # open-fonts
          oxygenfonts
          nerdfonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          siji
          # ucs-fonts
          unifont
          wqy_microhei
          wqy_zenhei
        ];
      };
    };
}
