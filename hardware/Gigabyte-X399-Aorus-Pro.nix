{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [];

  config = {
    time.hardwareClockInLocalTime = true;

    boot = {
      initrd.availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
        "it87"
      ];

      extraModulePackages = with config.boot.kernelPackages; [it87];
    };
  };
}
