{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../dependencies/nixos-hardware/lenovo/thinkpad/x1/7th-gen
  ];
  config = {
    boot = {
      initrd = {
        availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "aesni_intel" "cryptd" ];
        preLVMCommands = ''
echo "██╗   ██╗███████╗ ██████╗               ██████╗ ███████╗███╗   ██╗██╗   ██╗"
echo "██║   ██║██╔════╝██╔═══██╗              ██╔══██╗██╔════╝████╗  ██║╚██╗ ██╔╝"
echo "██║   ██║█████╗  ██║   ██║    █████╗    ██║  ██║█████╗  ██╔██╗ ██║ ╚████╔╝ "
echo "██║   ██║██╔══╝  ██║   ██║    ╚════╝    ██║  ██║██╔══╝  ██║╚██╗██║  ╚██╔╝  "
echo "╚██████╔╝██║     ╚██████╔╝              ██████╔╝███████╗██║ ╚████║   ██║   "
 echo "╚═════╝ ╚═╝      ╚═════╝               ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   "
        '';
      };
      kernelModules = [ "kvm-intel" ];
    };

    hardware.cpu.intel.updateMicrocode = true;
    hardware.enableAllFirmware = true;
    hardware.trackpoint = {
      enable = true;
      sensitivity = 32;
      speed = 32;
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement.cpuFreqGovernor = "powersave";
    services = {
      acpid = {
        enable = true;
      };

      fprintd.enable = true;
      # thermald.enable = true;
      throttled.enable = false;
    };
  };
}
