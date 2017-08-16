{ config, pkgs, lib, ... } :
with lib;
let
  cfg = config.services.status-tty;
in {
  options =
  {
    services.status-tty =
    {
      enable = mkOption
      {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable
  {
    # systemd.services."getty@tty1".enable = false;
    # systemd.services."autovt@".enable = false;

    systemd.services."autovt@tty1" =
    {
      description = "Status";
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
      {
        ExecStart = "${pkgs.atop}/bin/atop 2";
        Type="idle";
        Restart = "always";
        StandardInput = "null";
        StandardOutput = "tty";
        TTYPath = "/dev/tty1";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
        User = "nobody";
      };
      wants = [ "getty@tty2.service" ];
    };
  };
}
