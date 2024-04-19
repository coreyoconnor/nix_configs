{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.ufo-k8s;
in {
  options = {
    ufo-k8s = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [k3s];
    networking.firewall.allowedTCPPorts = [6443 config.services.dockerRegistry.port];
    services.dockerRegistry = {
      enable = true;
      enableDelete = true;
      enableGarbageCollect = true;
      listenAddress = "0.0.0.0";
    };
    services.k3s = {
      enable = true;
      role = "server";
    };
  };
}
