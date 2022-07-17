{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/AMD-A10-APU.nix
    ../../hardware/Gigabyte-F2A88XM-D3H.nix
    ../../network/home/host-agh.nix
    ../../network/home/resource-media-server.nix
    ../../network/home/resource-dns-server.nix
    ../../domains/primary
    ./filesystems.nix
    ./audio.nix
    ./gpu.nix
  ];

  config = {
    system.stateVersion = "22.05";

    libvirt-host.enable = true;

    services.fail2ban.enable = true;
    services.foreign-binary-emulation.enable = true;
    services.xserver.enable = false;

    virtualisation.podman.enable = true;
  };
}
