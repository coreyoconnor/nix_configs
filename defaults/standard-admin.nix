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
      neovim
    ];

    environment.variables.EDITOR = mkDefault "${neovim}/bin/nvim";

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services.openssh.enable = true;
  };
}
