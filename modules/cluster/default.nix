{ config, lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
    ./jenkins-master.nix
  ];
}
