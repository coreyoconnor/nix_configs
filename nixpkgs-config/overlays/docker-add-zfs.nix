self: super: {
  docker = super.docker_19_03.overrideAttrs (oldAttrs: rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });
}
