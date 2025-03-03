{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      fd
      fzf
      htop
      jq
      libsixel
      lm_sensors
      (nixpkgs-unstable.legacyPackages.${pkgs.system}.neovim)
      nix-index
      pciutils
      pcre
      ripgrep
      scrub
      tmux
      usbutils
      w3m
      wget
      xxd
    ];

    environment.variables.EDITOR = mkOverride 950 "${pkgs.neovim}/bin/nvim";

    programs = {
      direnv.enable = true;
      fish.enable = true;
    };

    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
        configFile = ''
          Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
          Defaults:root,%wheel env_keep+=TERMINFO_DIRS
        '';
      };

      forcePageTableIsolation = true;
      virtualisation.flushL1DataCache = "cond";
    };

    services.openssh.enable = true;

    users.defaultUserShell = pkgs.fish;
  };
}
