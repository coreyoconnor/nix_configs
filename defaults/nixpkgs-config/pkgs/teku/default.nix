{ lib, stdenv, fetchurl, makeWrapper, jre, jemalloc }:

stdenv.mkDerivation rec {
  pname = "teku";
  version = "22.9.1";

  src = fetchurl {
    url = "https://artifacts.consensys.net/public/teku/raw/names/teku.tar.gz/versions/${version}/teku-${version}.tar.gz";
    sha256 = "a4ab66e30cc24c99d14f91d31d95443cb0d12c984521837ec72e114af5cb5fd9";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r bin $out/
    mkdir -p $out/lib
    cp -r lib $out/
    wrapProgram $out/bin/${pname} --set JAVA_HOME "${jre}" --prefix LD_PRELOAD : "${jemalloc}/lib/libjemalloc.so";
  '';

  meta = with lib; {
    maintainers = with maintainers; [ coreyoconnor ];
  };
}
