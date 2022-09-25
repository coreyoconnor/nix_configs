{ config, pkgs, ... }:
let
  localIp = "192.168.86.2";
in {
  system.stateVersion = "18.09";

  require = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../dev.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

}
