# This is a generated file.  Do not modify!
# Make changes to /etc/nixos/configuration.nix instead.
{ config, pkgs, modulesPath, ... }:

{
  require = [
    "${modulesPath}/installer/scan/not-detected.nix"
  ];

  boot.initrd.kernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_hcd" ];
  boot.kernelModules = [ "acpi-cpufreq" ];
  boot.extraModulePackages = [ ];

  nix.maxJobs = 4;
}
