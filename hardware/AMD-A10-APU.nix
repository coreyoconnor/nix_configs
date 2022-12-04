{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    nix = {
      settings = {
        cores = 2;
        max-jobs = 0;
      };
    };

    boot = {
      kernelParams = [
        "amd_iommu=off"
      ];

      kernelModules = [ "kvm-amd" ];
    };
  };
}
