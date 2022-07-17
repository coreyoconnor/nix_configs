{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot = {
      blacklistedKernelModules = [ "radeon" ];
      kernelParams = [ "amdgpu.cik_support=1" "amdgpu.si_support=1" ];
    };

    hardware = {
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      opengl.enable = true;
    };
  };
}
