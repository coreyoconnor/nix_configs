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
    ../../network/home/resource-media-server.nix
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

    services.fail2ban = {
      enable = true;

      bantime-increment = {
        enable = true;
        maxtime = "200h";
      };
    };

    services.hw-rand.enable = true;

    services.nix-serve = {
      enable = true;
      port = 4999;
      secretKeyFile = "/etc/nix/ufo-1.sec";
    };

    services.qa-house-manager.enable = true;

    networking.firewall.allowedTCPPorts = [ 4999 ];

    nix = {
      extraOptions = ''
        keep-outputs = true
        secret-key-files = /etc/nix/ufo-1.sec
      '';
      settings = {
        cores = 3;
        max-jobs = 2;
      };
    };

    virt-host.enable = true;
  };
}

