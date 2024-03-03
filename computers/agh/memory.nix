{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [];

  config = {
    boot.kernel.sysctl = {
      "vm.swappiness" = 130;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 32000;
      }
    ];

    zramSwap = {
      enable = true;
      memoryPercent = 30;
    };
  };
}
