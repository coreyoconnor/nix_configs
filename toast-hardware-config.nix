# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, ... }:

{
  require = [
    <nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.initrd.kernelModules = [ "ohci_hcd" "ehci_hcd" "pata_amd" "ahci" "firewire_ohci" "usb_storage" "usbhid" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = 4;

  services.xserver.videoDrivers = [ "nvidia" ];
}
