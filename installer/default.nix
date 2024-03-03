{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../defaults
    ../domains/primary
    ../hardware/lenovo-thinkpad-x1-7th-gen.nix
    ../hardware/AMD-A10-APU.nix
    ../hardware/Gigabyte-F2A88XM-D3H.nix
    "${pkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  config = {
    environment.systemPackages = [pkgs.btrfs-progs];

    isoImage.isoBaseName = "my-nixos-installer";

    networking.firewall.enable = true;
    networking.enableIPv6 = false;

    services = {
      clamav = {
        updater.enable = true;
      };

      fprintd.enable = false;
      throttled.enable = false;
    };
  };
}
