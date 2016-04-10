{config, pkgs, lib, ...}:
with lib;
{
  config =
  {
    boot.blacklistedKernelModules = [ "snd_pcsp" ];
    sound.enable = true;
  };

  config.services =
  {
    dbus.enable = true;
    ntp.enable = true;
    udisks2.enable = true;
    upower.enable = true;
    acpid.enable = true;
    openssh =
    {
      enable = true;
    };
    nixosManual.showManual = true;

    dbus.packages =
    [
      pkgs.gnome.GConf
    ];

    syslogd.extraConfig = ''
        user.* /var/log/user
    '';

    xfs.enable = false;
  };
}
