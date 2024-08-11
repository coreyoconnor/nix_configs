{
  config,
  lib,
  pkgs,
  retronix,
  ...
}:
with lib; {
  imports = [
    ../../hardware/minisforum-UM350.nix
    ../../network/home/host-thrash.nix
    ../../domains/primary
    ./filesystems.nix
    ./audio.nix
    ./gpu.nix
    retronix.nixosModules.default
  ];

  config = {
    networking.hostName = "thrash";
    system.stateVersion = "22.05";

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    hardware.rasdaemon.enable = true;
    hardware.xpadneo.enable = true;

    media-presenter.enable = true;

    retronix = {
      enable = true;
      # steamLauncher = true;
      nick = "UFO";
      user = "media";
    };

    programs.gamemode.enable = true;

    services.foreign-binary-emulation.enable = true;

    virtualisation.podman.enable = true;
  };
}
