{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../hardware/surface-laptop-3-amd.nix
    ../domains/primary
    ../nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix
  ];

  config = {
    networking.firewall.enable = true;
    networking.enableIPv6 = false;
    isoImage.isoBaseName = "my-nixos-installer";
  };
}

