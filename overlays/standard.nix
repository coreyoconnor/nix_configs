self: super: {
  docker = super.docker_18_09.overrideAttrs (oldAttrs : rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });

  wine = super.winePackages.full.override {
    wineRelease = "staging";
    wineBuild = "wine32";
  };

  steamPackages = super.steamPackages // {
    steam-chrootenv = super.steamPackages.steam-chrootenv.override {
      extraPkgs = pkgs: [ pkgs.kde-cli-tools ];
    };
  };

  pkgsi686Linux = super.pkgsi686Linux // {
    stdenv = self.pkgsi686Linux.gcc6Stdenv;
  };
}
