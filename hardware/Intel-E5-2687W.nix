{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    nix.maxJobs = 2;

    nix.extraOptions = ''
        build-cores = 5
    '';

    boot = {
      kernelModules = [ "kvm-intel" "msr" ];
      kernelParams = [
        "kvm-intel.nested=1"
      ];
    };
  };
}
