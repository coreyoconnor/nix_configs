{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../dependencies/nixos-hardware/asus/hid-asus-mouse.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      piper
    ];
    hardware.hid-asus-mouse.enable = false;
    services.ratbagd.enable = true;
  };
}

