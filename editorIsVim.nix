{ config, pkgs, ... } :

with pkgs.lib;

{
    options =
    {
        environment.editorIsVim = mkOption
        {
            default = true;
            example = true;
            type = with types; bool;
            description = ''
                There is only vim.
            '';
        };
    };

    config = mkIf config.environment.editorIsVim 
    {
        environment.shellInit = ''
            export EDITOR=vim
        '';
        environment.systemPackages = [ pkgs.vim ];
    };
}

