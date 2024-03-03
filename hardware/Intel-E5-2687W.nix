{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
  ];

  config = {
    nix = {
      settings = {
        cores = 8;
        max-jobs = 2;
      };
    };

    boot = {
      kernelModules = ["kvm-intel" "msr"];
      kernelParams = [
        "kvm-intel.nested=1"
      ];
    };
  };
}
