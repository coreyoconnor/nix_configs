{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      kernelParams = [ "amdgpu.mcbp=0" "amd_iommu=off" ];
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    programs.gamemode.enable = true;
  };
}
