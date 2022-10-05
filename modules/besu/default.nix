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
    system.activationScripts.loginctl-besu-enable-linger-monkey = ''
      ${pkgs.systemd}/bin/loginctl enable-linger monkey || true
    '';

    environment.systemPackages = with pkgs; [
      besu
    ];

    systemd.user.services.besu = {
      wantedBy = [ "default.target" ];

      environment = {
        PODMAN_SYSTEMD_UNIT = "%n";
      };

      path = [ pkgs.coreutils config.virtualisation.podman.package pkgs.shadow pkgs.besu ];

      unitConfig = {
        ConditionUser = "monkey";
      };

      serviceConfig = {
        ExecStart = "${./start.sh} %t/%n.pid";
        ExecStartPre = [
          "-${pkgs.podman}/bin/podman stop --time 120 --ignore besu"
          "-${pkgs.podman}/bin/podman rm --force --ignore besu"
          "-${pkgs.coreutils}/bin/rm -rf %t/%n.pid"
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
