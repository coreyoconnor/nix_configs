{ config, pkgs, ... } :

with pkgs.lib;

{
  nixpkgs.config.packageOverrides = in_pkgs : rec
  { 
    haskellPackages = in_pkgs.haskellPackages_ghc783;
    hsEnv = in_pkgs.haskellPackages_ghc783.ghcWithPackagesOld (self : [
      self.ghcPaths
      self.async
      self.attoparsec
      self.caseInsensitive
      # self.cgi
      self.fgl
      self.GLUT
      self.GLURaw
      self.haskellSrc
      self.hashable
      self.html
      self.HTTP
      self.HUnit
      self.mtl
      self.network
      self.OpenGL
      self.OpenGLRaw
      self.parallel
      self.parsec
      self.QuickCheck
      self.random
      self.regexBase
      self.regexCompat
      self.regexPosix
      self.split
      self.stm
      self.syb
      self.text
      self.terminfo
      self.transformers
      self.unorderedContainers
      self.vector
      self.xhtml
      self.zlib
      self.cabalInstall
      self.alex
      # self.haddock_2_14_1
      self.happy
      self.primitive
      self.digest
      self.X11
      self.X11Xft
      # self.xmonad
      # self.xmonadContrib
      # self.xmonadExtras
      # self.pandoc
    ]);
  };

  nixpkgs.config.cabal.libraryProfiling = true;

  environment.systemPackages = 
  [ pkgs.hsEnv
  ];
}

