{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  pname = "s2i";
  version = "1.2.0";

  goPackagePath = "github.com/openshift/source-to-image";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "openshift";
    repo = "source-to-image";
    sha256 = "11vsicjdav6b1brsf62bpyvlivysy9y69i5d4il6pbm2apmsbczn";
  };
}
