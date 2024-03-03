{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/ASUS-Z9PA-D8.nix
    ../../hardware/Intel-E5-2687W.nix
    ../../network/home/host-grr.nix
    ../../network/home/resource-media-share.nix
    ../../domains/primary
    ./filesystems.nix
    ./memory.nix
    ./gpu.nix
  ];

  config = {
    networking.hostName = "agh";

    system.stateVersion = "22.05";

    developer-base.enable = true;

    semi-active-av.enable = true;

    services.foreign-binary-emulation.enable = true;
    services.hw-rand.enable = true;
    services.kbfs.enable = false;
    services.status-tty.enable = true;

    services.nix-serve = {
      enable = true;
      port = 4999;
      secretKeyFile = "/etc/nix/grr-1.sec";
    };

    nix = {
      extraOptions = ''
        keep-outputs = true
        secret-key-files = /etc/nix/grr-1.sec
      '';
    };

    virt-host.enable = true;
  };
}
