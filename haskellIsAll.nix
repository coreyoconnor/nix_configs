{ config, pkgs, ... } :

with pkgs.lib;

{
    options =
    {
        environment.haskellIsAll = mkOption
        {
            default = true;
            example = true;
            type = with types; bool;
            description = ''
                The haskell packages I expect.
            '';
        };
    };

    config = mkIf config.environment.haskellIsAll 
    {
        nixpkgs.config.packageOverrides = pkgs : 
            { 
                haskellPackages = pkgs.haskellPackages_ghc741;
                darcs = pkgs.haskellPackages_ghc6123.darcs;
            };

        nixpkgs.config.cabal.libraryProfiling = true;

        environment.systemPackages = 
            [ pkgs.haskellPackages.ghc
              pkgs.darcs
              pkgs.haskellPackages.yesod
              pkgs.haskellPackages.vty
              pkgs.haskellPackages.aeson
              pkgs.haskellPackages.httpConduit
              pkgs.haskellPackages.xmonad
              pkgs.haskellPackages.xmonadContrib
              pkgs.haskellPackages.QuickCheck
              pkgs.haskellPackages.monadsTf
              pkgs.haskellPackages.transformers
              pkgs.haskellPackages.cabalInstall_darcs
              pkgs.haskellPackages.cabalGhci
              # cabal2nix depends on these to build.
              pkgs.haskellPackages.hackageDb
              pkgs.haskellPackages.HTTP
              pkgs.haskellPackages.cabal2nix
              # broken, but I don't need it
              # pkgs.haskellPackages.xmonadExtras
              # XXX: in progress
              # pkgs.haskellPackages.yi
            ];
    };
}

