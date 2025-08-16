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

    hardware.bluetooth.enable = true;
    services.foreign-binary-emulation.enable = true;

    services.fail2ban = {
      # enable = true;

      bantime-increment = {
        enable = true;
        maxtime = "200h";
      };
    };

    services.hw-rand.enable = false;
    services.nix-serve = {
      enable = true;
      secretKeyFile = "/etc/nix/ufo-1.sec";
    };

    services.qa-house-manager.enable = true;

    nix = {
      extraOptions = ''
        keep-outputs = true
        secret-key-files = /etc/nix/ufo-1.sec
      '';
      settings = {
        cores = 8;
        max-jobs = 2;
      };
    };

    ufo-k8s.enable = true;
    virt-host.enable = true;
  };
}
