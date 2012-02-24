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
        environment.systemPackages = 
            [ pkgs.haskellPackages.ghc
              pkgs.haskellPackages_ghc6123.darcs
              pkgs.haskellPackages.yesod
              pkgs.haskellPackages.vty
              pkgs.haskellPackages.aeson
              pkgs.haskellPackages.httpConduit
              pkgs.haskellPackages.xmonad
              pkgs.haskellPackages.xmonadContrib
              pkgs.haskellPackages.QuickCheck
              pkgs.haskellPackages.monadsTF
              pkgs.haskellPackages.transformers
              # currently broken
              # pkgs.haskellPackages.cabalInstall_0_10_2
              pkgs.haskellPackages.cabalGhci
              pkgs.haskellPackages.cabal2nix
              # broken, but I don't need it
              # pkgs.haskellPackages.xmonadExtras
            ];
    };
}

