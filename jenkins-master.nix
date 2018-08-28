{config, pkgs, lib, ...}:
with lib;
let
  builderPackages = pkgs.symlinkJoin {
    name = "jenkins-builder-pkgs";
    paths = [ pkgs.bash
                 pkgs.docker
                 pkgs.openshift
                 pkgs.stdenv
                 pkgs.git
                 pkgs.jdk
                 pkgs.libvirt
                 pkgs.openssh
                 pkgs.nix
                 pkgs.gzip
                 pkgs.curl
                 pkgs.xorg.xorgserver
                 pkgs.qemu
               ];
  };
in {
  require = [ ./jenkins-node.nix ];

  services.jenkins =
  {
    enable = true;
    packages = [ builderPackages ];
  };

  networking =
  {
    firewall.allowedTCPPorts = [ 8080 53251 ];
  };
}
