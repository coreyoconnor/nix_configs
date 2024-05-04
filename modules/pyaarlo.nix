{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  click,
  unidecode,
  cloudscraper,
  paho-mqtt,
  cryptography,
}:
buildPythonPackage rec {
  pname = "pyaarlo";
  version = "0.8.0.6";

  src = fetchFromGitHub {
    owner = "twrecked";
    repo = "pyaarlo";
    rev = "a8c7d491f1bef7ffbdfc9e18357bb96172a02582";
    sha256 = "sha256-hiZ0v9wwqoBW7ObKWhsw0i/AdfF/xFW7+1yNqQ/8+8g=";
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
    license = with licenses; [lgpl3Plus];
  };
}
