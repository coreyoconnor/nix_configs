{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    nix = {
      extraOptions = ''
        build-cores = 8
      '';
      maxJobs = 2;
    };

    boot = {
      kernelModules = [ "kvm-amd" ];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
