self: super:
{
  docker = super.docker_18_09.overrideAttrs (oldAttrs : rec {
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

  kdenlive = (super.kdenlive.overrideAttrs (oldAttrs: rec {
    name = "kdenlive-${version}";
    version = "18.09.0";
    # rev = "9f538006790de8aab79549af192c90f0bd9ef359";
    rev = "eb994a4fef7a081b52f58e599d5c35f0958051b7";

    src = self.fetchgit {
      inherit rev;
      url = "git://anongit.kde.org/kdenlive.git";
     #  sha256 = "1anm0fjqk0in1vwvyzbm5pqyr8cypspvakj1q61g03x06qg10vqd";
      sha256 = "1b1d67yd4xfxv5paazclmn58cyban9g33zr9g9rxvw2rn0jiq0k4";
    };

    buildInputs = oldAttrs.buildInputs ++ [ self.libsForQt5.kdeclarative self.libsForQt5.kpurpose ];
  })).override {
    mlt = self.mlt;
  };

  mlt = super.mlt.overrideAttrs( oldAttrs: rec {
    name = "mlt-${version}";
    version = "6.11.1";
    src = self.fetchFromGitHub {
      owner = "mltframework";
      repo = "mlt";
      rev = "7dd25b4a6098b6413c5ee1adbde550c9ee951053";
      sha256 = "0sq1y2h7hp4rd4gci13imfiqnz52p7kpd0c7182z27iwhd0q9z8v";
    };
  });

  movit = super.movit.overrideAttrs( oldAttrs: rec {
    name = "movit-${version}";
    version = "1.6.2";

    buildInputs = oldAttrs.buildInputs ++ [ self.SDL2 ];
    doCheck = false;
    GTEST_DIR = "${self.gtest.src}/googletest";

    src = self.fetchurl {
      url = "https://movit.sesse.net/${name}.tar.gz";
      sha256 = "1q9h086v6h3da4b9qyflcjx73cgnqjhb92rv6g4j90m34dndaa3l";
    };
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

  qemu = super.qemu.overrideAttrs (oldAttrs: rec {
    name = "qemu-${version}";
    version = "3.1.0-rc1";
    src = self.fetchurl {
      url = "https://download.qemu.org/qemu-3.1.0-rc1.tar.xz";
      sha256 = "1wsvbnbklb8fgfsx0n2h7n3y5zhavdkq3gybjqmzm0anp5yrcadg";
    };
    patches = [ ./link-speed.patch ] ++ oldAttrs.patches;
  });

  metals = self.writeShellScriptBin "metals" ''
    exec ${self.jre8}/bin/java \
      -XX:+UseG1GC \
      -XX:+UseStringDeduplication  \
      -Xss4m \
      -Xms1G \
      -Xmx8G \
      -jar ${self.coursier}/bin/.coursier-wrapped launch \
      -r bintray:scalameta/maven \
      -r bintray:scalacenter/releases \
      ch.epfl.scala:bsp4j:2.0.0-M2 \
      org.scalameta:metals_2.12:0.2.0-SNAPSHOT \
      -M scala.meta.metals.Main
  '';
}
