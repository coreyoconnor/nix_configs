self: super: {
  keyd = super.keyd.overrideAttrs (oldAttrs: {
    src = assert (self.lib.versionOlder oldAttrs.version "2.5.1"); self.fetchFromGitHub {
      owner = "rvaiya";
      repo = "keyd";
      rev = "f010d00d8469b90d59911086166e66dceb2dd70f";
      hash = "sha256-d9S67Byj/aWIT1I3eOReMblO9mmchpt6rCFA7LaVddo=";
    };
  });
}
