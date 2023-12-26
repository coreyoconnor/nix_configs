{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/Gigabyte-X399-Aorus-Pro.nix
    ../../hardware/AMD-Ryzen-2920X.nix
    ../../network/home/host-glowness.nix
    ../../domains/primary
    ./filesystems.nix
    ./memory.nix
    ./gpu.nix
  ];

  config = {
    desktop.enable = true;
    developer-base.enable = true;

    environment.systemPackages = with pkgs; [
      chiaki
    ];

    hardware.spacenavd.enable = true;

    networking.firewall.enable = false;

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

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
