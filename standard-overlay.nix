self: super:
{
  nix-serve = super.nix-serve.overrideAttrs (oldAttrs: rec
  {
    rev = "d5aef668c9d5ffc3f29d8404bc2696cd7a9065d3";

    src = self.fetchgit
    {
      rev = "d5aef668c9d5ffc3f29d8404bc2696cd7a9065d3";
      url = "https://github.com/coreyoconnor/nix-serve.git";
      sha256 = "13286pyac2zn66qm4sba25kvrdcv1jpm738dkql6hygw777r0dqy";
    };
  });
}
