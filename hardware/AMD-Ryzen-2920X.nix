{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [];

  config = {
    nix = {
      settings = {
        cores = 8;
        max-jobs = 2;
      };
    };

    boot = {
      kernelModules = ["kvm-amd"];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}
