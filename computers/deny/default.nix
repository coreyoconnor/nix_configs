{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./filesystems.nix
    ./memory.nix
    ../../hardware/lenovo-thinkpad-x1-7th-gen.nix
    ../../domains/primary
  ];

  config = {
    desktop.enable = true;
    developer-base.enable = true;
    networking.firewall.enable = true;
    networking.enableIPv6 = false;

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    virt-host.enable = true;

    virtualisation = {
      containers.enable = true;
      waydroid.enable = true;
      lxd.enable = true;
    };
  };
}
