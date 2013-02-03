{config, pkgs, ...}:
with pkgs.lib;
{
  config =
  {
    services.dbus.enable = true;
    services.udisks.enable = true;
    services.upower.enable = true;
    services.acpid.enable = true;

    services.pulseaudio.enable = true;

    # Add an OpenSSH daemon.
    services.openssh.enable = true;

    # XXX: Disables both X11 forwarding for the client as well as server.
    # I only want to disable X11 forwarding for ssh client
    services.openssh.forwardX11 = false;

    # Add the NixOS Manual on virtual console 8
    services.nixosManual.showManual = true;

    services.dbus.packages =
    [
      pkgs.gnome.GConf
    ];

    services.syslogd.extraConfig = ''
        user.* /var/log/user
    '';

    services.xfs.enable = false;
  };
}

