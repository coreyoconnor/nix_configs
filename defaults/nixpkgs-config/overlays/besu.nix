self: super: {
  besu = super.besu.overrideAttrs (finalAttrs: previousAttrs: {
    version = "22.7.3";
    src = self.fetchurl {
      url = "https://hyperledger.jfrog.io/artifactory/${finalAttrs.pname}-binaries/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
      sha256 = "sha256-sIY/4kBsq1fK+KAvK/AmMsxRmGIqxItpvGPBKHA7vXk=";
    };
  });
}
