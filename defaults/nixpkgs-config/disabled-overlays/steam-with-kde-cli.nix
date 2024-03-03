self: super: {
  steamPackages =
    super.steamPackages
    // {
      steam-chrootenv = super.steamPackages.steam-chrootenv.override {
        extraPkgs = pkgs: [pkgs.kde-cli-tools];
      };
    };
}
