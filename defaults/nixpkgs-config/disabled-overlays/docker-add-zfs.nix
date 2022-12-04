self: super: {
  docker = super.docker.overrideAttrs (oldAttrs: rec {
    moby = oldAttrs.moby.overrideAttrs (mobyOldAttrs: {
      extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + mobyOldAttrs.extraPath;
    });
  });
}
