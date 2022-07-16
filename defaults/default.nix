{ config, pkgs, lib, ... }:
with lib; rec {
  imports = [
    ./nixpkgs-config.nix
    ./foreign-binary-emulation.nix
    ./standard-admin.nix
    ./standard-env.nix
    ./standard-services.nix
  ];

  options = { };

  config = {
    i18n.defaultLocale = "en_US.UTF-8";

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

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
      ];
    };
  };
}
