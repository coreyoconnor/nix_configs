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
      nerd-fonts-symbols-only
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
          # google-fonts
          helvetica-neue-lt-std
          inconsolata
          # junicode
          # open-fonts
          oxygenfonts
          noto-fonts-cjk-serif
          noto-fonts-color-emoji
          siji
          # ucs-fonts
          unifont
        ];
      };
    };
}
