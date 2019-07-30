self: super: {
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
