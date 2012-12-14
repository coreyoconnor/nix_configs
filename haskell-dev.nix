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
        nixpkgs.config.packageOverrides = in_pkgs : 
            { 
                haskellPackages = in_pkgs.haskellPackages_ghc742_profiling;
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

