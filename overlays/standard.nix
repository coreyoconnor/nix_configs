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
