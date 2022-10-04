{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.teku;
in {
  options = {
    services.teku = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
  };
}
