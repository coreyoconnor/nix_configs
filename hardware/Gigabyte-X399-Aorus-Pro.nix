{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot.initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];
  };
}
