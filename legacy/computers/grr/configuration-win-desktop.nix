{ config, pkgs, ... }:

{
  require = [ ./common-configuration.nix ./windows-desktop-vm.nix ];

  services.xserver.enable = false;
}
