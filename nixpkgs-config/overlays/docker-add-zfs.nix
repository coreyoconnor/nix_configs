self: super: {
  docker = super.docker_18_09.overrideAttrs (oldAttrs : rec {
    extraPath = super.lib.makeBinPath [ self.zfs ] + ":" + oldAttrs.extraPath;
  });
}
