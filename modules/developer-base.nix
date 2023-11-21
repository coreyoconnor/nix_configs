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
      autoconf
      automake
      bloop
      buildah
      clang
      conmon
      coursier
      git
      jdk
      keybase
      libsecret # for secret-tool
      lua-language-server
      sbt
      scala-cli
      zig
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;
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
