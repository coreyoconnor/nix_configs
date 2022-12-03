{ config, pkgs, lib, ... }:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      jq
      htop
      nix-index
      screen
      tmux
      vim
    ];

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services.openssh.enable = true;
  };
}
