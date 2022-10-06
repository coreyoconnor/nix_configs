{ config, lib, pkgs, ... }: {
  imports = [
    ./hosts.nix
    ./lan.nix
  ];

  config = {
    cluster.jenkins-master = {
      enable = false;
      host = "agh";
    };
  };
}
