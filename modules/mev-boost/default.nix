{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.mev-boost;
in {
  imports = [];

  options = {
    services.mev-boost = {
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

    networking.firewall.allowedTCPPorts = [18550];

    systemd.user.services.mev-boost = {
      wantedBy = ["default.target"];

      environment = {
        PODMAN_SYSTEMD_UNIT = "%n";
      };

      path = ["/run/wrappers" pkgs.coreutils config.virtualisation.podman.package pkgs.shadow];

      unitConfig = {
        ConditionUser = "monkey";
        RequiresMountsFor = "/mnt/storage/validator";
      };

      serviceConfig = {
        ExecStart = "${./start.sh} %t/%n.pid";
        ExecStartPre = [
          "-${pkgs.podman}/bin/podman stop --time 120 --ignore mev-boost"
          "-${pkgs.podman}/bin/podman rm --force --ignore mev-boost"
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
