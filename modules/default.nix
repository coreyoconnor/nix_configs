{
  config,
  lib,
  pkgs,
  modulesPath,
  sway-gnome,
  ...
}:
with lib; {
  imports = [
    ./atmo-monitor.nix
    ./besu
    ./desktop.nix
    ./developer-base.nix
    ./foreign-binary-emulation.nix
    ./hw-rand.nix
    ./media-presenter.nix
    ./mev-boost
    ./qa-house-manager.nix
    ./retronix-default-session.nix
    ./semi-active-av.nix
    ./status-tty.nix
    ./teku
    ./virt-host.nix
    sway-gnome.nixosModules.default
  ];
}
