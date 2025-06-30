{
  config,
  pkgs,
  lib,
  nixpkgs-unstable,
  ...
}:
with lib;
let
  cfg = config.developer-base;
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
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
      cloudflared # for cloudflare tunnel ssh connections
      conmon
      coursier
      git
      jdk
      keybase
      kubectl
      kubernetes-helm
      libsecret # for secret-tool
      lua-language-server
      sbt
      scala-cli
      zig
      nixpkgs-unstable-pkgs.gemini-cli
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

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nproc";
        value = "unlimited";
      }
      {
        domain = "*";
        type = "-";
        item = "nofile";
        value = "1048576";
      }
    ];

    systemd.extraConfig = "DefaultLimitNOFILE=4096:1048576";
  };
}
