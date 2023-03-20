{ config, pkgs, lib, ... }: {
  imports = [
    ../../nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix
    ../../network/home
    ../../domains/primary
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_latest;
    hardware.enableRedistributableFirmware = true;

    nixpkgs.overlays = [
      (self: super: {
        zfs = super.zfs.overrideAttrs (finalAttrs: previousAttrs: {
          meta = previousAttrs.meta // { platforms = []; broken = true; };
        });
      })
    ];
  };
}
