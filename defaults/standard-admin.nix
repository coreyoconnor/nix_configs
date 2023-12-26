{ config, pkgs, lib, ... }:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      fd
      fzf
      htop
      jq
      lm_sensors
      lsix
      neovim
      nix-index
      pciutils
      pcre
      ripgrep
      screen
      scrub
      tmux
      usbutils
      w3m
      wget
      xxd
    ];

    environment.variables.EDITOR = mkOverride 950 "${pkgs.neovim}/bin/nvim";

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    security.forcePageTableIsolation = true;
    security.virtualisation.flushL1DataCache = "cond";

    services.openssh.enable = true;
  };
}
