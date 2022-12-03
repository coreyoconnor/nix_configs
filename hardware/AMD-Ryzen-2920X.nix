{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot = {
      kernelModules = [ "kvm-amd" ];
    };
  };
}
