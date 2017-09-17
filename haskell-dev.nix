{ config, pkgs, lib, ... } :
with lib;

let hsPkgs = self : with self; [
  ghc-paths
  async
  attoparsec
  case-insensitive
  # self.cgi
  # fgl
  # GLUT
  # GLURaw
  haskell-src
  hashable
  # self.html
  HTTP
  HUnit
  mtl
  network
  # OpenGL
  # OpenGLRaw
  parallel
  parsec
  QuickCheck
  random
  regex-base
  regex-compat
  regex-posix
  split
  stm
  syb
  text
  # self.terminfo
  transformers
  unordered-containers
  vector
  # self.xhtml
  zlib
  cabal-install
  alex
  # self.haddock_2_14_1
  happy
  primitive
  digest
  # self.X11
  # self.X11Xft
  # self.xmonad
  # self.xmonadContrib
  # self.xmonadExtras
  # self.pandoc
];

in {
  nixpkgs.config =
  {
    haskellPackageOverrides = self: super: {
      mkDerivation = expr: super.mkDerivation (expr // { enableLibraryProfiling = true; });
    };

    packageOverrides = super: let self = super.pkgs; in
    {
      hsEnv = self.haskellPackages.ghcWithPackages hsPkgs;
    };
  };

  nixpkgs.config.cabal.libraryProfiling = true;

  environment.systemPackages = [ pkgs.hsEnv ];
}
