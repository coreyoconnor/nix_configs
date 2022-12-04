{ config, pkgs, lib, ... }:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      fzf
      jq
      htop
      nix-index
      pcre
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
