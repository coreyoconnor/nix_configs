self: super: {
  gjs = gjs.overrideDerivation (_: { doCheck = !(self.stdenv.isDarwin || self.stdenv.isAarch64); });
}

