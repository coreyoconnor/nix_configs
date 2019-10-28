{ config, pkgs, ... } :
let androidsdk = pkgs.androidsdk_9_0;
in {
  config = {
    # TODO: Just using pkgs.jdk with icedtea will point to a directory without
    # a proper lib directory. EG: tools.jar is missing.
    environment.shellInit = ''
      export ANDROID_HOME=${androidsdk}
      export JAVA_HOME=${pkgs.jdk}/lib/openjdk
    '';

    environment.systemPackages = with pkgs; [
      ammonite
      androidsdk
      maven3
      jdk
      metals
      sbt
      scala
    ];

    nixpkgs.config = {
      android_sdk.accept_license = true;

      cabal.libraryProfiling = true;

      haskellPackageOverrides = self: super: {
        mkDerivation = expr: super.mkDerivation (expr // { enableLibraryProfiling = true; });
      };
    };

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
