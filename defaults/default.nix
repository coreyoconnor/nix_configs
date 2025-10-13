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
        download-buffer-size = 201326592;
      };
    };

    programs = {
      nix-index.enable = true;
      command-not-found.enable = false;
    };
  };
}
