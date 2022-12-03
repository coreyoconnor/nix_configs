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
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "yes";

    boot.plymouth.enable = true;

    developer-base.enable = true;
    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    nix = {
      extraOptions = ''
        keep-outputs = true
      '';
    };

    virt-host.enable = true;

    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
  };
}
