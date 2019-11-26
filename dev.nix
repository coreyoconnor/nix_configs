{ config, pkgs, ... }:
let androidsdk = pkgs.androidsdk_9_0;
in {
  config = {
    environment.shellInit = ''
      export ANDROID_HOME=${androidsdk}
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages = with pkgs; [
      ammonite
      androidsdk
      ansible
      git
      maven3
      jdk
      metals
      operator-sdk
      qemu
      sbt
      scala
      vagrant
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;

      cabal.libraryProfiling = true;

      haskellPackageOverrides = self: super: {
        mkDerivation = expr:
          super.mkDerivation (expr // { enableLibraryProfiling = true; });
      };
    };

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
