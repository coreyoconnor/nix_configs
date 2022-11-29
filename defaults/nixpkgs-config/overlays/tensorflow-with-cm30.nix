self: super:
let
  gcc7Protobuf = import <nixpkgs/pkgs/development/libraries/protobuf/generic-v3.nix> {
    inherit (self) lib fetchFromGitHub autoreconfHook zlib gtest;

    version = "3.19.5";
    sha256 = "sha256-C5ZfPXHtUtNjPGS4tbswCwVH1gjd6A64KtIR16DgHzQ=";

    stdenv = self.gcc7Stdenv;
    buildPackages = self.buildPackages // { stdenv = self.buildPackages.gcc7Stdenv; };
  };
in {
  inherit gcc7Protobuf;

  python3 = super.python3.override {
    packageOverrides = python-self: python-super: {
      protobuf = python-super.protobuf.override {
        protobuf = gcc7Protobuf;
        buildPackages = self.buildPackages // { protobuf = gcc7Protobuf; };
      };

      tensorflow-build = python-super.tensorflow-build.override {
        cudaSupport = true;
        cudaPackages = self.cudaPackages_10_2;
        cudaCapabilities = [ "sm_30" ];
        sse42Support = true;
        avx2Support = true;
        xlaSupport = false; # sm_30 does not support xla
        protobuf-core = gcc7Protobuf;
        protobuf-python = python-self.protobuf;
        stdenv = self.gcc7Stdenv;
      };
    };
  };
}
