{config, pkgs, ...}:
with pkgs.lib;
{
  config.hardware =
  {
    pulseaudio.enable = true;
  };

  config.services =
  {
    dbus.enable = true;
    ntp.enable = true;
    udisks.enable = true;
    upower.enable = true;
    acpid.enable = true;

    # Add an OpenSSH daemon.
    openssh.enable = true;

    # XXX: Disables both X11 forwarding for the client as well as server.
    # I only want to disable X11 forwarding for ssh client
    openssh.forwardX11 = false;

    # add the NixOS Manual on virtual console 8
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

