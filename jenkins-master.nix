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
    extraJavaOptions = [
      "-Dhudson.slaves.WorkspaceList=-"
      "-Djava.awt.headless=true"
      "-Dhudson.model.DirectoryBrowserSupport.CSP=\"default-src 'self'; script-src 'self' 'unsafe-inline';\""
    ];
    packages = [ builderPackages ];
  };

  networking =
  {
    firewall.allowedTCPPorts = [ 8080 53251 ];
  };
}
