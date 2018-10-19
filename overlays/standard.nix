self: super:
{
  docker = self.docker_18_06;

  docker_18_06 = super.docker_18_06.overrideAttrs (oldAttrs : rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });

  #emacs = super.emacs.overrideAttrs (oldAttrs : rec {
  #  version = "26.1RC1";
  #  name = "emacs-${version}";
  #  src = self.fetchurl {
  #      url = "ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-26.1-rc1.tar.xz";
  #      sha256 = "6594e668de00b96e73ad4f168c897fe4bca7c55a4caf19ee20eac54b62a05758";
  #  };
  #  patches = [];
  #});

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

  kdenlive = super.kdenlive.overrideAttrs (oldAttrs: rec {
    name = "kdenlive-${version}";
    version = "18.18.0";
    rev = "77bdbfd5589b5be07456dce0c24df4a5f5a34e59";

    src = self.fetchgit {
      inherit rev;
      url = "git://anongit.kde.org/kdenlive.git";
      sha256 = "1y5fj4vcwlmz8np89ymwzy1divdz89cq6i3s584pbxayl1k3j3hx";
    };

    buildInputs = oldAttrs.buildInputs ++ [ self.libsForQt5.kdeclarative self.libsForQt5.kpurpose ];
  });

  #qgis3-unwrapped = super.qgis3-unwrapped.overrideAttrs (oldAttrs: rec
  #{
  #  rev = "240278e490f6d5bb065a9faebe199702e5b5b3a0";
#
#    src = self.fetchgit
#    {
#      inherit rev;
#      url = "https://github.com/coreyoconnor/QGIS.git";
#      sha256 = "0qwijz34j76sv4g1y98qsz96p79zy49xh3w0hhb3jp5s96dhvq2z";
#    };
#  });

  qgis = super.qgis3;

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

  #nix = super.nixStable.overrideAttrs (oldAttrs: rec
  #{
  #  rev = "ac198373c3e0e9520fa067e6a6761797f39d5b60";
#
#    src = self.fetchgit
#    {
#      inherit rev;
#      url = "https://github.com/coreyoconnor/nix.git";
#      sha256 = "1xxhl1cl81fkj47hygqlgr0jzfqlkn6272iwr53rylz80naslvxb";
#    };
#    fromGit = true;
#
#    nativeBuildInputs = with self; [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl pkgconfig boost ];
#
#    inherit (super.nixStable) perl-bindings;
#  });

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

  #systemd = super.systemd.overrideAttrs (oldAttrs: rec {
  #  src = self.fetchgit {
  #    url = "https://github.com/coreyoconnor/systemd.git";
  #    sha256 = "1f991f3n6drcy6cjs4f199c7xrr3jc36l52chb68jg16i1hl92n6";
  #    rev = "3264ddaadd09de1849177aeba8bf24ddfae88822";
  #  };
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
}
