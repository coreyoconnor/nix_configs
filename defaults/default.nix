{ config, pkgs, lib, ... }:
with lib;
let zfsLinuxPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
in rec {
  imports = [
    ./nixpkgs-config.nix
    ./fonts.nix
    ./standard-admin.nix
    ./standard-env.nix
    ./standard-services.nix
    ./udev.nix
  ];

  options = {
    default.graphical = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    boot.kernelPackages = mkDefault zfsLinuxPackages;

    boot.loader.grub = {
      fontSize = 24;
    };

    console = {
      font = mkDefault "Lat2-Terminus16";
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

    time.timeZone = lib.mkDefault "UTC";

    services.journald.console = "/dev/tty12";
  };
}
