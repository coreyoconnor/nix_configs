{ config, lib, pkgs, modulesPath, ... }:
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
      fuse-overlayfs
      git
      gradle
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
      slirp4netns
      stdenv
      utillinux
    ];
  };
in {
  imports = [
    ./jenkins-node.nix
  ];

  options.cluster.jenkins-master = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };

    host = mkOption {
      default = "jenkins-master";
      example = "agh";
      type = with types; str;
    };
  };

  config = mkIf (
    config.cluster.jenkins-master.enable && (
      config.networking.hostName == config.cluster.jenkins-master.host
    )
  ) {
    cluster.jenkins-node.enable = true;

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
  };
}
