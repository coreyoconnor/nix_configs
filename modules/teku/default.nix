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
    system.activationScripts.loginctl-teku-enable-linger-monkey = ''
      ${pkgs.systemd}/bin/loginctl enable-linger monkey || true
    '';

    environment.systemPackages = with pkgs; [
      teku
    ];

    systemd.user.services.teku = {
      wantedBy = [ "default.target" ];

      environment = {
        PODMAN_SYSTEMD_UNIT = "%n";
      };

      path = [ "/run/wrappers" pkgs.coreutils config.virtualisation.podman.package pkgs.shadow pkgs.teku ];

      unitConfig = {
        ConditionUser = "monkey";
        RequiresMountsFor = "/mnt/storage/validator";
      };

      serviceConfig = {
        Delegate="yes"; # required for CPU limits?
        ExecStart = "${./start.sh} %t/%n.pid";
        ExecStartPre = [
          "-${pkgs.podman}/bin/podman stop --time 120 --ignore teku"
          "-${pkgs.podman}/bin/podman rm --force --ignore teku"
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
