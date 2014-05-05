{ config, pkgs, ... } :

with pkgs.lib;

{
  options =
  {
    hardware.enableAcerPrimus = mkOption
    {
      default = false;
      example = true;
      type = with types; bool;
      description = ''
        Enable primus support for acer laptop
      '';
    };
  };

  config = mkMerge
  [
    (mkIf config.hardware.enableAcerPrimus
    {
      hardware.bumblebee.enable = true;
    })

    (mkIf (config.hardware.enableAcerPrimus == false)
    {
      hardware.nvidiaOptimus.disable = true;
    })
  ];
}

