{config, pkgs, ...} :
{
  systemd =
  {
    services.battery-logging =
    {
      description = "poll battery status";
      path = [ pkgs.acpi ];
      script = ''
        acpi -b
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
        OnUnitActiveSec = "10min";
        Unit = "battery-logging.service";
      };
    };
  };
}
