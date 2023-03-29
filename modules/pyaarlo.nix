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
  version = "0.8.0b6";

  src = fetchFromGitHub {
    owner = "twrecked";
    repo = "pyaarlo";
    rev = "77c202b6f789c7104a024f855a12a3df4fc8df38";
    sha256 = "sha256-/XHqiyuVZGjJGgc+r35vVMTERQ9FlJrtMWs9+2wKGkk=";
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
