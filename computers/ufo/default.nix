{
  config,
  lib,
  pkgs,
  nixos-hardware,
  ...
}:
with lib; {
  imports = [
    ../../domains/primary
    ../../network/home
    ./boot.nix
    ./filesystems.nix
    ./memory.nix
    nixos-hardware.nixosModules.supermicro
    nixos-hardware.nixosModules.common-cpu-intel
  ];
  config = {
    networking.hostId = "abab4ab2";
    networking.hostName = "ufo";
    networking.useDHCP = lib.mkDefault true;

    system.stateVersion = "23.11";

    developer-base.enable = true;
    semi-active-av.enable = true;
    services.foreign-binary-emulation.enable = true;

    virt-host.enable = true;
  };
}

