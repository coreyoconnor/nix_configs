{config, pkgs, ...}:
with pkgs.lib;
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
    udisks.enable = true;
    upower.enable = true;
    acpid.enable = true;
    openssh =
    {
      enable = true;
      forwardX11 = true;
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

