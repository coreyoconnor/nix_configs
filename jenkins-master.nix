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
                 pkgs.libvirt
                 pkgs.openssh
                 pkgs.nix
                 pkgs.gzip
                 pkgs.curl
                 pkgs.xorg.xorgserver
                 pkgs.qemu
                 pkgs.rsync
               ];
  };
in {
  require = [ ./jenkins-node.nix ];

  services.jenkins =
  {
    enable = true;
    environment = {
      JAVA_HOME = "${pkgs.jdk}/jre";
    };
    extraJavaOptions = [
      "-Dhudson.slaves.WorkspaceList=-"
      "-Djava.awt.headless=true"
      "-Dhudson.model.DirectoryBrowserSupport.CSP=\"default-src 'self'; script-src 'self' 'unsafe-inline' ajax.googleapis.com cdnjs.cloudflare.com netdna.bootstrapcdn.com; style-src 'self' 'unsafe-inline' cdnjs.cloudflare.com netdna.bootstrapcdn.com; font-src 'self' netdna.bootstrapcdn.com; img-src 'self' data:\""
    ];
    # a pkgs.jdk in builderPackages is not longer included in bin. nixpkgs bug
    packages = [ pkgs.jdk builderPackages ];
  };

  networking =
  {
    firewall.allowedTCPPorts = [ 8080 53251 ];
  };
}
