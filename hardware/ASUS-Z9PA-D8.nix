{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      initrd.availableKernelModules = [
        "ehci_pci"
        "ahci"
        "mpt3sas"
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sr_mod"
      ];

      kernelParams = [
        "pcie_aspm=off"
        "rcutree.rcu_idle_gp_delay=1"
      ];
    };
  };
}
