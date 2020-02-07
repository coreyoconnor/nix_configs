{ config, pkgs, ... }:
{
  require = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../editorIsVim.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  options = {
    networking.interfaces.enp2s0f0.useDHCP = true;
  };
}
