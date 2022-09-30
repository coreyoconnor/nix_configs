{ config, lib, pkgs, ... }:
with lib; {
  config = {
    boot.kernel.sysctl = { "vm.nr_hugepages" = 16484; };
    hardware.mcelog.enable = true;

    services.udev.extraRules = ''
      ACTION=="add", KERNEL=="mcelog", SUBSYSTEM=="misc", TAG+="systemd", ENV{SYSTEMD_WANTS}+="mcelog.service"
    '';

    zramSwap = {
      enable = true;
      memoryPercent = 20;
    };
  };
}
