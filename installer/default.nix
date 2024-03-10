{
  config,
  lib,
  pkgs,
  nixpkgs,
  nixos-hardware,
  ...
}:
with lib; {
  imports = [
    ../domains/primary
    ../network/home
    ../hardware/lenovo-thinkpad-x1-7th-gen.nix
    ../hardware/AMD-A10-APU.nix
    ../hardware/Gigabyte-F2A88XM-D3H.nix
    "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
    nixos-hardware.nixosModules.supermicro
    nixos-hardware.nixosModules.common-cpu-intel
  ];

  config = {
    networking.hostName = "my-nixos-installer";
    system.stateVersion = "23.11";

    boot = {
      loader.grub.memtest86.enable = true;
    };

    environment.systemPackages = with pkgs; [
      btrfs-progs
      pciutils
      stress-ng
    ];

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
