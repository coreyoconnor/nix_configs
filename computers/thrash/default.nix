{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ../../hardware/minisforum-UM350.nix
    ../../network/home/resource-media-share.nix
    ../../network/home/host-thrash.nix
  ];

  config = {
    system.stateVersion = "22.05";
  };
}
