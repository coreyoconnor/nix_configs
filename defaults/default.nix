{ config, pkgs, lib, ... }:
with lib; rec {
  imports = [
    ./nixpkgs-config.nix
    ./foreign-binary-emulation.nix
    ./hw-rand.nix
    ./standard-admin.nix
    ./standard-env.nix
    ./standard-services.nix
    ./status-tty.nix
    ./virt-host.nix
  ];

  config = {
    boot.loader.grub = {
      fontSize = 24;
    };

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

    hardware = {
      enableAllFirmware = lib.mkDefault true;
      enableRedistributableFirmware = lib.mkDefault true;
    };

    i18n.defaultLocale = "en_US.UTF-8";

    time.timeZone = "UTC";

    services.journald.console = "/dev/tty12";
  };
}
