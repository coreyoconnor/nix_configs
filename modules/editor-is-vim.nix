{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    environment.editor-is-vim = mkOption {
      default = true;
      example = true;
      type = with types; bool;
      description = ''
        There is only vim.
      '';
    };
  };

  config = mkIf config.environment.editor-is-vim {
    environment.shellInit = ''
      export EDITOR=vim
    '';
    environment.systemPackages = [ pkgs.vim ];
  };
}
