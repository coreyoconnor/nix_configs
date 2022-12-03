{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    nix = {
      extraOptions = ''
        build-cores = 8
      '';
      maxJobs = 2;
    };

    boot = {
      kernelModules = [ "kvm-intel" "msr" ];
      kernelParams = [
        "kvm-intel.nested=1"
      ];
    };
  };
}
