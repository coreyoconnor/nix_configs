self: super:
{
  qgis3-unwrapped = super.qgis3-unwrapped.overrideAttrs (oldAttrs: rec
  {
    rev = "240278e490f6d5bb065a9faebe199702e5b5b3a0";

    src = self.fetchgit
    {
      inherit rev;
      url = "https://github.com/coreyoconnor/QGIS.git";
      sha256 = "0qwijz34j76sv4g1y98qsz96p79zy49xh3w0hhb3jp5s96dhvq2z";
    };
  });

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

  nix = super.nixStable.overrideAttrs (oldAttrs: rec
  {
    rev = "ac198373c3e0e9520fa067e6a6761797f39d5b60";

    src = self.fetchgit
    {
      inherit rev;
      url = "https://github.com/coreyoconnor/nix.git";
      sha256 = "1xxhl1cl81fkj47hygqlgr0jzfqlkn6272iwr53rylz80naslvxb";
    };
    fromGit = true;

    nativeBuildInputs = with self; [ autoreconfHook autoconf-archive bison flex libxml2 libxslt docbook5 docbook5_xsl pkgconfig boost ];

    inherit (super.nixStable) perl-bindings;
  });

  wine = super.winePackages.full.override { wineRelease = "staging"; };
}
