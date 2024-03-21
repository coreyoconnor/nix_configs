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
    ./boot.nix
    ./filesystems.nix
    ./memory.nix
    ./network.nix
    nixos-hardware.nixosModules.supermicro
    nixos-hardware.nixosModules.common-cpu-intel
  ];
  config = {
    system.stateVersion = "23.11";

    developer-base.enable = true;
    semi-active-av.enable = true;
    services.foreign-binary-emulation.enable = true;

    virt-host.enable = true;

    nix = {
      settings = {
        cores = 4;
        max-jobs = 2;
      };
    };
  };
}

