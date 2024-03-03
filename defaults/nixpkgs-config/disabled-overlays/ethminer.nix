self: super: {
  ethminer = super.ethminer.override {
    stdenv = self.clangStdenv;
  };
}
