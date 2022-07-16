{ config, pkgs, lib, ... }:
with lib;
let
  builderPackages = pkgs.symlinkJoin {
    name = "jenkins-builder-pkgs";
    paths = with pkgs; [
      ammonite
      ansible
      ansible-bender
      buildah
      bash
      curl
      docker
      docker-pushrm
      fuse-overlayfs
      git
      gzip
      jq
      libvirt
      nfs-utils
      nix
      openshift
      openssh
      podman
      procps
      qemu
      rsync
      runc
      sbt
      s2i
      slirp4netns
      stdenv
      utillinux
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
    packages = [ pkgs.jdk builderPackages  ];
  };

  networking = { firewall.allowedTCPPorts = [ 8080 53251 ]; };
}
