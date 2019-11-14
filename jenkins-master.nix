{ config, pkgs, lib, ... }:
with lib;
let
  builderPackages = pkgs.symlinkJoin {
    name = "jenkins-builder-pkgs";
    paths = with pkgs; [
      ansible
      bash
      curl
      docker
      git
      gzip
      libvirt
      nix
      openshift
      openssh
      procps
      qemu
      rsync
      stdenv
      vagrant
      xorg.xorgserver
    ];
  };
in {
  require = [ ./jenkins-node.nix ];

  services.jenkins = {
    enable = true;
    environment = { JAVA_HOME = "${pkgs.jdk}/jre"; };
    extraJavaOptions = [
      "-Dhudson.slaves.WorkspaceList=-"
      "-Djava.awt.headless=true"
      ''
        -Dhudson.model.DirectoryBrowserSupport.CSP="default-src 'self'; script-src 'self' 'unsafe-inline' ajax.googleapis.com cdnjs.cloudflare.com netdna.bootstrapcdn.com; style-src 'self' 'unsafe-inline' cdnjs.cloudflare.com netdna.bootstrapcdn.com; font-src 'self' netdna.bootstrapcdn.com; img-src 'self' data:"''
    ];
    # a pkgs.jdk in builderPackages is not longer included in bin. nixpkgs bug
    packages = [ pkgs.jdk builderPackages ];
  };

  networking = { firewall.allowedTCPPorts = [ 8080 53251 ]; };
}
