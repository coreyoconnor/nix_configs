{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    nix = {
      maxJobs = 2;
    };

    boot = {
      kernelParams = [
        "amd_iommu=off"
      ];
    };
  };
}
