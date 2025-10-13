{
  config,
  pkgs,
  lib,
  ...
}:
with lib; rec {
  imports = [
    ./nix-flake-support.nix
    ./nix-gc.nix
    ./user-admin-auth.nix
  ];

  config = {
    nix = {
      settings = {
        download-buffer-size = mkDefault 201326592;
      };
    };

    programs = {
      nix-index.enable = mkDefault true;
      command-not-found.enable = mkDefault false;
    };
  };
}
