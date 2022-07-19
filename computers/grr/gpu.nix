{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    hardware = {
      nvidia = {
        modesetting.enable = true;
        nvidiaPersistenced = true;
      };

      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    virtualisation.docker.enableNvidia = true;
  };
}
