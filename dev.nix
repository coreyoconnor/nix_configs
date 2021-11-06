{ config, pkgs, ... }:
{
  config = {
    environment.shellInit = ''
      export JAVA_HOME=${pkgs.jdk}
    '';

    environment.systemPackages = with pkgs; [
      ammonite
      ansible
      ansible-bender
      ansible-python-support
      bloop
      buildah
      conmon
      coursier
      docker-pushrm
      fuse-overlayfs
      git
      jdk
      jq
      maven3
      # operator-sdk
      podman
      qemu
      runc
      sbt
      slirp4netns
      s2i
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

    programs.ssh = {
      extraConfig = ''
        ForwardAgent yes
      '';
      startAgent = true;
    };

    /*
    virtualisation.cri-o = {
      enable = true;
      storageDriver = "vfs";
    };
    */
  };
}
