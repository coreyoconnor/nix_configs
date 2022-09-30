{ config, pkgs, lib, ... }: {
  imports = [
    ../../nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix
    ../../network/home
    ../../domains/primary
  ];

  config = {
    hardware.enableRedistributableFirmware = true;
  };
}
