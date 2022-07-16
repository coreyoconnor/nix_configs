{ config, pkgs, lib, ... }:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      jq
      nix-index
      screen
      tmux
    ];
  };
}
