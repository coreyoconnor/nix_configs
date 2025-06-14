{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  nerdfonts-pkgs = if builtins.hasAttr "nerd-fonts" pkgs
    then with pkgs.nerd-fonts; [
      fira-code
      droid-sans-mono
      inconsolata
      comic-shanns-mono
      symbols-only
    ]
    else [
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode" "DroidSansMono" "Inconsolata"
          "ComicShannsMono" "DroidSansMono"
          "Monoid"
          "NerdFontsSymbolsOnly"
        ];
      })
    ];
in {
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

        enableDefaultPackages = true;

        packages = with pkgs; nerdfonts-pkgs ++ [
          anonymousPro
          corefonts
          courier-prime
          dejavu_fonts
          fira-mono
          helvetica-neue-lt-std
          inconsolata
          oxygenfonts
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          siji
          unifont
        ];
      };
    };
}
