{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot = {
      kernelParams = [
        "amd_iommu=off"
      ];


      kernelModules = [ "kvm-amd" ];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
