{ config, pkgs, ... }:

{
  require =
  [
    ./common-configuration.nix
    ./windows-desktop-vm.nix
    ../../desktop.nix
  ];

  services.xserver.enable = false;
}
