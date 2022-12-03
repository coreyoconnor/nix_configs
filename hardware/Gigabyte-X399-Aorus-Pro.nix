{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  };
}
