{ config, pkgs, lib, ... }:
with lib;
let cfg = config.atmo-monitor;
in {
  options = {
    atmo-monitor = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.atmo-monitor = {
      description = "tails the serial data from /dev/ttyACM0";
      path = [ pkgs.coreutils ];
      script = ''
        mkdir -p -m 0755 /var/run/atmo-monitor
        stty -F /dev/ttyACM0 speed 115200
        cat /dev/ttyACM0
      '';
    };

    systemd.services.atmo-monitor-photo = {
      path = [ pkgs.fswebcam ];
      unitConfig = {
        RequiresMountsFor = "/mnt/storage/media";
      };
      serviceConfig = {
        User = "coconnor";
      };
      script = ''
        fswebcam -d /dev/video0 -r 3264x2448  \
          --skip 2 --jpeg 95 -F 10 --no-banner \
          --save '/mnt/storage/media/Pictures/atmo-monitor/monitor-0-%Y%m%d-%H%M%S.jpg' \
          -s brightness=50% -s exposure=50% -s 'White Balance Temperature, Auto=false'  \
          -s 'White Balance Temperature=6200'
      '';
    };

    systemd.timers.atmo-monitor-photo = {
      partOf = [ "atmo-monitor-photo.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = "*:0/30";
    };
  };
}
