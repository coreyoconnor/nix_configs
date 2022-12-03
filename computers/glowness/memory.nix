{ config, lib, pkgs, ... }:
with lib; {
  config = {
    boot.kernel.sysctl = { "vm.nr_hugepages" = 8242; };

    zramSwap = {
      enable = true;
      memoryPercent = 20;
    };
  };
}
