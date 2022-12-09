{ config, lib, pkgs, modulesPath, ... }:
with lib;
let sway-gnome = import ../dependencies/sway-gnome {
      inherit pkgs lib;
    };
in {
  imports = [
    ./atmo-monitor.nix
    ./besu
    ./cluster
    ./desktop.nix
    ./developer-base.nix
    ./editor-is-vim.nix
    ./foreign-binary-emulation.nix
    ./hw-rand.nix
    ./media-presenter.nix
    ./mev-boost
    ./qa-house-manager.nix
    ./retronix.nix
    ./status-tty.nix
    ./teku
    ./virt-host.nix
    sway-gnome.module
  ];
}
