# not required. upower logs power usage better. Just a small experiment in using timers.
{config, pkgs, ...} :
{
  systemd =
  {
    services.battery-logging =
    {
      description = "poll battery status";
      path = [ pkgs.acpi ];
      script = ''
        echo "$(date -R) $(acpi -b)" >> /var/log/battery.log
      '';
      serviceConfig.Type = "oneshot";
    };

    timers.battery-logging =
    {
      description = "triggers poll of battery status";
      wantedBy = [ "basic.target" ];
      timerConfig =
      {
        OnBootSec = "5min";
        OnUnitActiveSec = "5min";
        Unit = "battery-logging.service";
      };
    };
  };
}
