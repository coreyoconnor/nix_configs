self: super: {
  docker = super.docker.overrideAttrs (oldAttrs: rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });
}
