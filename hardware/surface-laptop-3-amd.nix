{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../dependencies/nixos-hardware/microsoft/surface/surface-laptop-amd
  ];

  config = {
    # TODO https://github.com/linux-surface/linux-surface/wiki/Surface-Laptop-3
    boot = {
      initrd.kernelModules = [ 
        "surface_aggregator" 
        "surface_aggregator_registry" 
        "surface_aggregator_hub" 
        "surface_hid_core"
        "surface_hid"
        "8250_dw"
      ];

      extraModprobeConfig = mkDefault ''
        options ath10k_core skip_otp=Y
      '';
    };

    hardware.enableAllFirmware = true;

    # "Note: This should no longer be required with up-to-date firmware from the official linux-firmware
    # repository."
    #hardware.firmware = [
    #  (pkgs.callPackage ./surface-laptop-3-ath10k-replace.nix {})
    #];
  };
}
