{ config, lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
    ./atmo-monitor.nix
    ./cluster
    ./developer-base.nix
    ./editor-is-vim.nix
    ./foreign-binary-emulation.nix
    ./hw-rand.nix
    ./media-presenter.nix
    ./retronix.nix
    ./status-tty.nix
    ./virt-host.nix
  ];
}
