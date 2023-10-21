{ config, lib, pkgs, ... }:
with lib; {
  config = {
    hardware.mcelog.enable = true;
    services.udev.extraRules = ''
      ACTION=="add", KERNEL=="mcelog", SUBSYSTEM=="misc", TAG+="systemd", ENV{SYSTEMD_WANTS}+="mcelog.service"
    '';

    zramSwap = {
      enable = true;
      memoryPercent = 30;
    }
  };
}
