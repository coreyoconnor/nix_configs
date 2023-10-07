{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    boot = {
      kernelParams = [ "amdgpu.mcbp=0" "amd_iommu=off" ];
    };
  };
}
