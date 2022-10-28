{ lib
, buildPythonPackage
, fetchFromGitHub
, pycryptodome
, click
, unidecode
, cloudscraper
, paho-mqtt
, cryptography
}:

buildPythonPackage rec {
  pname = "pyaarlo";
  version = "0.7.1.3";

  src = fetchFromGitHub {
    owner = "twrecked";
    repo = "pyaarlo";
    rev = "ab02c70173b0f9ce637a98969a91f6a5b1abd5cf";
    sha256 = "sha256-wePfnt6UcPzgYw6+YdFsJ+Y26bVP4xrcpHiGgCvErBg=";
  };

  doCheck = false;

  propagatedBuildInputs = [
    pycryptodome
    click
    unidecode
    cloudscraper
    paho-mqtt
    cryptography
  ];

  meta = with lib; {
    homepage = https://github.com/twrecked/pyaarlo;
    license = with licenses; [ lgpl3Plus ];
  };
}
