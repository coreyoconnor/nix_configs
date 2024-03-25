{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../hardware/AMD-A10-APU.nix
    ../../hardware/Gigabyte-F2A88XM-D3H.nix
    ../../network/home/host-agh.nix
    ../../domains/primary
    ./filesystems.nix
    ./memory.nix
    ./audio.nix
    ./gpu.nix
  ];

  config = {
    networking.hostName = "agh";
    system.stateVersion = "22.05";

    developer-base.enable = true;
    semi-active-av.enable = true;

    nix = {
      settings = {
        cores = 2;
        max-jobs = 0;
      };
    };

    services.dnsmasq.enable = false;

    services.fail2ban = {
      enable = true;

      bantime-increment = {
        enable = true;
        maxtime = "200h";
      };
    };
    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = false;
    services.openssh.settings.PasswordAuthentication = false;
    services.samba.enable = false;
    services.xserver.enable = false;
    services.qa-house-manager.enable = false;
  };
}
