{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/minisforum-UM350.nix
    ../../network/home/host-thrash.nix
    ../../network/home/resource-media-share.nix
    ../../domains/primary
    ./filesystems.nix
    ./audio.nix
    ./video.nix
  ];

  config = {
    hardware.bluetooth.enable = true;
    hardware.xpadneo.enable = true;

    media-presenter.enable = true;

    retronix = {
      enable = true;
      nick = "UFO";
      user = "media";
    };

    programs.gamemode.enable = true;

    services.foreign-binary-emulation.enable = true;

    virtualisation.podman.enable = true;
  };
}
