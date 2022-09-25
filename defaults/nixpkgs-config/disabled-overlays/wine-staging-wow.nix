self: super: {
  wine = super.winePackages.full.override {
    wineRelease = "staging";
    wineBuild = "wineWow";
  };
}
