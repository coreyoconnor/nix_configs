{ config, lib, pkgs, ... }:
with lib; {
  imports = [
  ];

  config = {
    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    virtualisation.podman.enableNvidia = true;
  };
}
