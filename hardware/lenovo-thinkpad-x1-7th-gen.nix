{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../dependencies/nixos-hardware/lenovo/thinkpad/x1/7th-gen
  ];
  config = {
    boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
    boot.kernelModules = [ "kvm-intel" ];

    hardware.enableAllFirmware = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement.cpuFreqGovernor = "powersave";
    hardware.cpu.intel.updateMicrocode = true;
    # services.thermald.enable = true;
    services.throttled.enable = false;
  };
}
