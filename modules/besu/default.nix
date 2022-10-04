{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.besu;
in {
  options = {
    services.besu = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.loginctl-enable-linger-monkey = ''
      ${pkgs.systemd}/bin/loginctl enable-linger monkey || true
    '';

    systemd.user.services.besu = {
      wantedBy = [ "default.target" ];

      environment = {
        PODMAN_SYSTEMD_UNIT = "%n";
      };

      path = [ config.virtualisation.podman.package pkgs.shadow ];

      unitConfig = {
        ConditionUser = "monkey";
      };

      serviceConfig = {
        ExecStart = "${./start.sh} %t/%n.pid";
        ExecStartPre = [
          "-rm -rf %t/%n.pid"
          "-podman stop --time 120 besu"
          "-podman rm --force besu"
        ];
        ExecStop = "${./stop.sh}";
        Group = "monkey";
        NotifyAccess = "all";
        PIDFile = "%t/%n.pid";
        Restart = "on-success";
        Type = "notify";
        TimeoutStopSec = 200;
      };
    };
  };
}
