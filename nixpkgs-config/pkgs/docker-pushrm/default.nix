{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-pushrm";
  version = "1.0.3";

  src = fetchFromGitHub {
    rev = "fd6bd5f59601acbcd5aca89d7e8d2c8bebb8f9ad";
    owner = "glngn";
    repo = "docker-pushrm";
    sha256 = "0vyr25g5d34n55w2mwbnlg1vx7591aabhp4srvjz00kkbmv1rf8w";
  };

  modSha256 = "03mjz60zm03hrsa1c55lrnqcc43iyw989al862rir998w86ibkgq";
  vendorSha256 = "0hx1fm9cd02a5cdwigmv2vzxvfvmyafgnadcrnhzaf86xp7ivyil";
}
