{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      kernelModules = [ "kvm-intel" "msr" ];
      kernelParams = [
        "kvm-intel.nested=1"
      ];
    };
  };
}
