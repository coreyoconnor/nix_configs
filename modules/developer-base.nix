{ config, pkgs, lib, ... }:
with lib;
let cfg = config.developer-base;
in {
  options = {
    developer-base = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages = with pkgs; [
      ammonite
      ansible
      autoconf
      automake
      bloop
      buildah
      conmon
      coq
      coursier
      docker-pushrm
      emacs
      fuse-overlayfs
      git
      jdk
      jq
      maven3
      podman
      qemu
      runc
      sbt
      scala-cli
      silver-searcher
      slirp4netns
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;

      cabal.libraryProfiling = true;
    };

    programs.ssh = {
      extraConfig = ''
        ForwardAgent yes
      '';
      startAgent = true;
    };

    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nproc";
      value = "unlimited";
    }];
  };
}
