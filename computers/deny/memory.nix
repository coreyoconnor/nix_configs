{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
    boot.kernel.sysctl = {
      "vm.swappiness" = 130;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.page-cluster" = 0;
    };

    hardware.rasdaemon.enable = true;

    zramSwap = {
      enable = true;
      memoryPercent = 30;
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 10000;
      }
    ];
  };
}
