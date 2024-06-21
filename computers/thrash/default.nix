{
  config,
  lib,
  pkgs,
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
  ];

  config = {
    networking.hostName = "thrash";
    system.stateVersion = "22.05";

    hardware.bluetooth.enable = true;
    hardware.rasdaemon.enable = true;
    hardware.xpadneo.enable = true;

    media-presenter.enable = true;

    retronix = {
      enable = true;
      nick = "UFO";
      user = "media";
    };

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
    };

    services.foreign-binary-emulation.enable = true;

    virtualisation.podman.enable = true;
  };
}
