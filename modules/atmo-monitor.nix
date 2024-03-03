{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.atmo-monitor;
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
      path = [pkgs.coreutils pkgs.gnugrep];
      wantedBy = ["multi-user.target"];
      script = ''
        mkdir -p -m 0755 /var/run/atmo-monitor
        stty -F /dev/ttyACM0 speed 115200 > /dev/null
        cat /dev/ttyACM0
      '';
    };

    systemd.services.atmo-monitor-photo = {
      path = [pkgs.fswebcam];
      unitConfig = {
        RequiresMountsFor = "/mnt/storage/media";
      };
      serviceConfig = {
        User = "coconnor";
      };
      script = ''
        fswebcam -d /dev/video0 -r 3264x2448  \
          --skip 2 --jpeg 98 -F 15 --no-banner \
          --save '/mnt/storage/media/Pictures/atmo-monitor/monitor-0-%Y%m%d-%H%M%S.jpg' \
          -s 'White Balance Temperature, Auto=false'  \
          -s 'White Balance Temperature=6500' \
          -s 'Exposure, Auto Priority=False' -s 'Exposure (Absolute)=8000' \
          -s 'Gain=40' -s 'Brightness=5' \
          -s 'Focus, Auto=False' -s 'Focus (absolute)=70'
      '';
    };

    systemd.timers.atmo-monitor-photo = {
      partOf = ["atmo-monitor-photo.service"];
      wantedBy = ["timers.target"];
      timerConfig.OnCalendar = "*:0/30";
    };
  };
}
