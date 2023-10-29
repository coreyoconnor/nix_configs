{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../dependencies/nixos-hardware/lenovo/thinkpad/x1/7th-gen
  ];
  config = {
    boot = {
      initrd = {
        availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
      };
      kernelModules = [ "kvm-intel" ];
    };

    hardware.cpu.intel.updateMicrocode = true;

    hardware.enableAllFirmware = true;

    hardware.trackpoint = {
      enable = true;
      sensitivity = 16;
      speed = 16;
    };

    nixpkgs.hostPlatform = "x86_64-linux";

    services = {
      acpid = {
        enable = true;
      };

      fprintd.enable = mkDefault true;
      # throttled.enable = mkDefault false;
    };
  };
}
