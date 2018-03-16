self: super:
{
  nix-serve = super.nix-serve.overrideAttrs (oldAttrs: rec
  {
    rev = "b2deefaa8d185989a9bba06254d6f7dcc7dbb764";

    src = self.fetchgit
    {
      rev = "b2deefaa8d185989a9bba06254d6f7dcc7dbb764";
      url = "https://github.com/coreyoconnor/nix-serve.git";
      sha256 = "1dgp2741lh9iib8qs8xmy8d0jdb9990iif1n3ql9rj3g8yv00kin";
    };
  });

  nixUnstable = super.nixUnstable.overrideAttrs (oldAttrs: rec
  {
    rev = "48662d151bdf4a38670897beacea9d1bd750376a";

    src = self.fetchgit
    {
      rev = "48662d151bdf4a38670897beacea9d1bd750376a";
      url = "https://github.com/NixOS/nix.git";
      sha256 = "0avrdd5k138s2zlrwabxd60dz8jzhil0z29sdqs1g1cm5yxx83cp";
    };
  });

  wine = super.winePackages.full.override { wineRelease = "unstable"; };
}
