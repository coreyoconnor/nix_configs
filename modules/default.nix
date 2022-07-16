{ config, lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
    ./editor-is-vim.nix
    ./media-presenter.nix
    ./retronix.nix
  ];
}
