self: super: {
  gjs = super.gjs.overrideDerivation (_: {doCheck = !(self.stdenv.isDarwin || self.stdenv.isAarch64);});
}
