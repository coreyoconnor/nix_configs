self: super: let
  src = self.fetchgit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "9c0536deda9f72ed736cbb35b4ab806ab192035f";
    sha256 = "17pd3iwgp3w468vsb36z6a88dlrjhd4z8aa9i0nk5xp99ahkqf34";
  };
in {home-manager = super.callPackage "${src}/home-manager" {path = src;};}
