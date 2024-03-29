{
  config,
  pkgs,
  nixpkgs,
  lib,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    ../../network/home
    ../../domains/primary
  ];

  config = {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;
    hardware.enableRedistributableFirmware = true;

    boot.kernel.sysctl = {
      "vm.swappiness" = 120;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    zramSwap.enable = true;

    nixpkgs.overlays = [
      (self: super: {
        makeModulesClosure = x: super.makeModulesClosure (x // {allowMissing = true;});

        zfs = super.zfs.overrideAttrs (finalAttrs: previousAttrs: {
          meta =
            previousAttrs.meta
            // {
              platforms = [];
              broken = true;
            };
        });
      })
    ];
  };
}
