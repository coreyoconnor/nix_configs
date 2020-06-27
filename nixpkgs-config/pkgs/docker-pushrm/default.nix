{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

buildGoModule rec {
  pname = "docker-pushrm";
  version = "1.0.3";

  # goPackagePath = "github.com/christian-korneck/docker-pushrm";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "christian-korneck";
    repo = "docker-pushrm";
    sha256 = "1zj09giyxaaw07fqs61npjxh6c87kysd5zkbn0kn7y9yjwi5wfa0";
  };

  vendorSha256 = "0hx7fm9cd02a5cdwigmv2vzxvfvmyafgnadcrnhzaf86xp7ivyil";
}
