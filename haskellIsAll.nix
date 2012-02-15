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
              # pkgs.haskellPackages.yesod
              pkgs.haskellPackages.vty
              pkgs.haskellPackages.xmonad
              pkgs.haskellPackages.xmonadContrib
              # pkgs.haskellPackages.xmonadExtras
            ];
    };
}

