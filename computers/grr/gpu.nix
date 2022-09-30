{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    boot.kernelPackages = pkgs.linuxPackages_5_15;

    hardware = {
      nvidia = {
        modesetting.enable = false;

        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

        nvidiaPersistenced = true;
        nvidiaSettings = false;
      };

      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    nixpkgs.config.cudaSupport = true;

    # required to actually enable the nvidia driver
    services.xserver.videoDrivers = [ "nvidia" ];

    virtualisation.docker.enableNvidia = true;
  };
}
