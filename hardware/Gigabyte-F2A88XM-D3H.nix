{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    boot = {
      initrd.availableKernelModules =
        [ "xhci_hcd" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" ];
    };
  };
}
