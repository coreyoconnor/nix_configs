self: super: {
  winePackages = self.wineWow64Packages;
  wine64Forwarder = self.stdenv.mkDerivation {
    name = "wine64Forwarder";
    buildCommand = ''
      mkdir -p $out/bin/
      ln -s "${self.wine}/bin/wine" $out/bin/wine64
    '';
  };
}
