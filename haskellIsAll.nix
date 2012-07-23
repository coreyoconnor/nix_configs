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
            };

        nixpkgs.config.cabal.libraryProfiling = true;

        environment.systemPackages = 
            [ pkgs.darcs
              ( pkgs.haskellPackages.ghcWithPackages (self : [
                    self.haskellPlatform
              ]))
            ];
    };
}

