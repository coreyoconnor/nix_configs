{ options, pkgs, lib, ... }:
with lib; {
  config = {
    boot.blacklistedKernelModules = [ "snd_pcsp" ];

    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 30d";
      };

      optimise.automatic = true;
    };

    networking.timeServers = options.networking.timeServers.default ++ [
      "0.us.pool.ntp.org"
      "1.us.pool.ntp.org"
      "2.us.pool.ntp.org"
      "3.us.pool.ntp.org"
    ];

    programs.dconf.enable = true;
    programs.gnupg.agent.enable = true;

    services = {
      acpid.enable = true;
      avahi = {
        enable = true;
        ipv6 = false;
        nssmdns = true;
        openFirewall = true;
      };

      dbus.enable = true;

      fstrim.enable = true;

      openssh.enable = true;

      syslogd.extraConfig = ''
        user.* /var/log/user
      '';

      udisks2.enable = true;
      upower.enable = true;
    };

    systemd.tmpfiles.rules = [ "R /tmp/nix* - - - 60d" "R! /tmp/* - - - 6m" ];
  };
}
