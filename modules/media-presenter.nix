{ config, lib, pkgs, modulesPath, ... }:
with lib;
let cfg = config.media-presenter;
in {
  options = {
    media-presenter = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      das_watchdog.enable = true;
    };
  };
}
