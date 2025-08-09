{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  imports = [ inputs.ucodenix.nixosModules.default ];

  config = {
    nix = {
      settings = {
        cores = 8;
        max-jobs = 2;
      };
    };

    boot = {
      kernelModules = ["kvm-amd"];
      # boot.kernelParams = [ "microcode.amd_sha_check=off" ];
    };

    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    services.ucodenix = {
      enable = true;
      cpuModelId = "00800F82";
    };
  };
}
