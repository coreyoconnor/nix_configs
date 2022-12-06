{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/Gigabyte-X399-Aorus-Pro.nix
    ../../hardware/AMD-Ryzen-2920X.nix
    ../../network/home/host-glowness.nix
    ../../network/home/resource-media-share.nix
    ../../domains/primary
    ./filesystems.nix
    ./memory.nix
    ./gpu.nix
  ];

  config = {
    desktop.enable = true;
    developer-base.enable = true;
    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

    virt-host.enable = true;

    virtualisation = {
      waydroid.enable = true;
      lxd.enable = true;
    };
  };
}
