{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../network/home/host-grr.nix
    ../../network/home/resource-media-share.nix
    ../../domains/primary
    ./gpu.nix
  ];

  config = {
    system.stateVersion = "22.05";

    services.foreign-binary-emulation.enable = true;

    virtualisation.podman.enable = true;
  };
}
