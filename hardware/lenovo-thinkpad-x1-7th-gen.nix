{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
with lib; {
  imports = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x1-7th-gen
  ];
  config = {
    boot = {
      initrd = {
        availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "aesni_intel" "cryptd"];
      };
      kernelModules = ["kvm-intel" "i915" ];
    };

    # i915 is not compatible with RT
    desktop.rt = false;

    hardware.cpu.intel.updateMicrocode = true;

    hardware.enableAllFirmware = true;

    hardware.trackpoint = {
      enable = true;
      sensitivity = 16;
      speed = 16;
    };

    services = {
      acpid = {
        enable = true;
      };

      fprintd.enable = mkDefault true;
      # throttled.enable = mkDefault false;
    };
  };
}
