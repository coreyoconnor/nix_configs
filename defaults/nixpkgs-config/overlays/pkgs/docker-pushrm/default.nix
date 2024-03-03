{
  lib,
  buildGoModule,
  fetchurl,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "docker-pushrm";
  version = "1.0.4";

  src = fetchFromGitHub {
    rev = "a7136fa0d414cff035a871415b5a51763c3e41f6";
    owner = "glngn";
    repo = "docker-pushrm";
    sha256 = "1is1nn9gs5zqh0an985j7i6xc0azd3gwndrh9ng5m5ayv76rah97";
  };

  modSha256 = "03mjz60zm03hrsa1c55lrnqcc43iyw989al862rir998w86ibkgq";
  vendorSha256 = "0hx7fm9cd02a5cdwigmv2vzxvfvmyafgnadcrnhzaf86xp7ivyil";
}
