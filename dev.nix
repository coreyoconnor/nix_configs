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
      ansible-python-support
      buildah
      conmon
      fuse-overlayfs
      git
      jdk
      maven3
      metals
      operator-sdk
      podman
      qemu
      runc
      sbt
      slirp4netns
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

    environment.etc."containers/policy.json" = {
      mode="0644";
      text=''
        {
          "default": [
            {
              "type": "insecureAcceptAnything"
            }
          ],
          "transports":
          {
            "docker-daemon":
            {
              "": [{"type":"insecureAcceptAnything"}]
            }
          }
        }
      '';
    };

    environment.etc."containers/registries.conf" = {
      mode="0644";
      text=''
        [registries.search]
          registries = ['docker.io', 'quay.io']
      '';
    };

    /*
    virtualisation.cri-o = {
      enable = true;
      storageDriver = "vfs";
    };
    */
  };
}
