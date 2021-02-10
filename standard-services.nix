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

    programs.mosh.enable = true;

    services = {
      dbus = {
        enable = true;
      };
      udisks2.enable = true;
      upower.enable = true;
      acpid.enable = true;
      openssh = { enable = true; };

      syslogd.extraConfig = ''
        user.* /var/log/user
      '';
    };

    systemd.tmpfiles.rules = [ "R /tmp/nix* - - - 60d" "R! /tmp/* - - - 6m" ];
  };
}
