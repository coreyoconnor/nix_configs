{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  zfsLinuxPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
in rec {
  imports = [
    ./nixpkgs-config.nix
    ./fonts.nix
    ./standard-admin.nix
    ./standard-nix.nix
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
    # 6.10 is broken and since 6.8, 6.9 were removed this must be 6.6
    boot.kernelPackages = mkDefault zfsLinuxPackages;

    console = {
      keyMap = "us";
    };

    environment = {
      pathsToLink = ["/share" "/etc/gconf"];

      shellInit = ''
        export LC_ALL=${config.i18n.defaultLocale}
      '';
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
