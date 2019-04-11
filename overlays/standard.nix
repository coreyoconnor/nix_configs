self: super: {
  docker = super.docker_18_09.overrideAttrs (oldAttrs : rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });

  godot = super.godot.overrideAttrs (oldAttrs: rec
  {
    name = "godot-${version}";
    version = "3.1.0";
    rev = "8068d0217a5e74c25f83fe93fa6e077b8d0b3bf5";

    src = self.fetchgit
    {
      inherit rev;
      url = "https://github.com/coreyoconnor/godot.git";
      sha256 = "1g1k2j7cwm47k13gk9v0x1kxrvs3c36dkqxrnpcb13y11s4mbk47";
    };

    patches = [
      ./godot-pkg-config-additions.patch
      ./godot-3-1-sconstruct.patch
    ];

    installPhase = ''
      mkdir -p "$out/bin"
      cp bin/godot.* $out/bin/godot

      mkdir "$dev"
      cp -r modules/gdnative/include $dev

      mkdir -p "$man/share/man/man6"
      cp misc/dist/linux/godot.6 "$man/share/man/man6/"

      mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
      cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
      cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
      cp icon.png "$out/share/icons/godot.png"
      substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
        --replace "Exec=godot" "Exec=$out/bin/godot"
    '';
  });

  nix-serve = super.nix-serve.overrideAttrs (oldAttrs: rec
  {
    rev = "b2deefaa8d185989a9bba06254d6f7dcc7dbb764";

    src = self.fetchgit
    {
      inherit rev;
      url = "https://github.com/coreyoconnor/nix-serve.git";
      sha256 = "1dgp2741lh9iib8qs8xmy8d0jdb9990iif1n3ql9rj3g8yv00kin";
    };
  });

  openshift-dev = self.openshift.overrideAttrs (oldAttrs: rec {
    version = "3.10.0";
    name = "openshift-origin-${version}";

    src = self.fetchFromGitHub {
        owner = "openshift";
        repo = "origin";
        rev = "8705cafdd5dcb8331aed889179616306297e6b2f";
        sha256 = "0017xk59carvp8kh2xfvkdlk0487437w14iychx8r5shssq3hs3q";
    };

    k8sversion = "v1.10.2";
    k8sgitcommit = "a0ce2bc657";
    versionMajor = "3";
    versionMinor = "10";
    versionPatch = "0";
    gitCommit = "44a7ea441";

    buildPhase = ''
      echo "KUBE_GIT_MAJOR=1" >> os-version-defs
      echo "KUBE_GIT_MINOR=10" >> os-version-defs
    '' + oldAttrs.buildPhase;

    patches = [ ./openshift-assume-nsenter.patch ];

    postPatch = ''
        patchShebangs ./hack

        substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
            --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt findmnt' \
                      'nsenter --mount=/rootfs/proc/1/ns/mnt ${self.utillinux}/bin/findmnt'

        substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
            --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mount' \
                      'nsenter --mount=/rootfs/proc/1/ns/mnt ${self.utillinux}/bin/mount'

        substituteInPlace pkg/oc/clusterup/docker/host/host.go  \
            --replace 'nsenter --mount=/rootfs/proc/1/ns/mnt mkdir' \
                      'nsenter --mount=/rootfs/proc/1/ns/mnt ${self.utillinux}/bin/mount'
    '';
  });

  #openshift = super.openshift.overrideAttrs (oldAttrs: rec {
  #  patches = [ ./openshift-assume-version.patch ];
  #});

  wine = super.winePackages.full.override {
    wineRelease = "staging";
    wineBuild = "wine32";
  };

  steamPackages = super.steamPackages // {
    steam-chrootenv = super.steamPackages.steam-chrootenv.override {
      extraPkgs = pkgs: [ pkgs.kde-cli-tools ];
    };
  };

  qemu = super.qemu.overrideAttrs (oldAttrs: rec {
    patches = [ ./link-speed.patch ] ++ oldAttrs.patches;
  });
}
