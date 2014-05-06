{ config, pkgs, ... } :

with pkgs.lib;

{
  nixpkgs.config.packageOverrides = in_pkgs : rec
  { 
    haskellPackages = in_pkgs.haskellPackages_ghc783;
    hsEnv = in_pkgs.haskellPackages_ghc783.ghcWithPackagesOld (self : [
      self.ghcPaths
      self.async_2_0_1_5
      self.attoparsec_0_11_3_0
      self.caseInsensitive_1_2_0_0
      # self.cgi_3001_1_8_5
      self.fgl_5_4_2_4
      self.GLUT_2_5_1_0
      self.GLURaw_1_4_0_0
      self.haskellSrc_1_0_1_6
      self.hashable_1_2_1_0
      self.html_1_0_1_2
      self.HTTP_4000_2_13
      self.HUnit_1_2_5_2
      self.mtl_2_1_3_1
      self.network_2_5_0_0
      self.OpenGL_2_9_1_0
      self.OpenGLRaw_1_4_0_0
      self.parallel_3_2_0_4
      self.parsec_3_1_5
      self.QuickCheck_2_6
      self.random_1_0_1_1
      self.regexBase_0_93_2
      self.regexCompat_0_95_1
      self.regexPosix_0_95_2
      self.split_0_2_2
      self.stm_2_4_3
      self.syb_0_4_1
      self.text_1_1_1_1
      self.transformers_0_3_0_0
      self.unorderedContainers_0_2_4_0
      self.vector_0_10_9_1
      self.xhtml_3000_2_1
      self.zlib_0_5_4_1
      self.cabalInstall_1_18_0_3
      self.alex_3_1_3
      # self.haddock_2_14_1
      self.happy_1_19_3
      self.primitive_0_5_2_1
      self.terminfo_0_4_0_0
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

