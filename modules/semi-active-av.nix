{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.semi-active-av;
  sus-user-dirs = [
    "Downloads"
  ];
  all-normal-users = attrsets.filterAttrs (username: config: config.isNormalUser) config.users.users;
  all-sus-dirs =
    builtins.concatMap
    (
      dir:
        attrsets.mapAttrsToList
        (username: config: config.home + "/" + dir)
        all-normal-users
    )
    sus-user-dirs;
  all-user-folders = attrsets.mapAttrsToList (username: config: config.home) all-normal-users;
  all-system-folders = [
    "/boot"
    "/etc"
    "/nix"
    "/root"
    "/usr"
  ];
  notify-all-users =
    pkgs.writeScript "notify-all-users-of-sus-file"
    ''
      #!/bin/sh
      ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
      # Send an alert to all graphical users.
      for ADDRESS in /run/user/*; do
          USERID=''${ADDRESS#/run/user/}
         /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -i dialog-warning "Sus file" "$ALERT"
      done
    '';
in {
  options = {
    semi-active-av = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    security.sudo = {
      extraConfig = ''
        clamav ALL = (ALL) NOPASSWD: SETENV: ${pkgs.libnotify}/bin/notify-send
      '';
    };

    services.clamav.daemon = {
      enable = true;

      settings = {
        OnAccessIncludePath = all-sus-dirs;
        OnAccessPrevention = false;
        OnAccessExtraScanning = true;
        OnAccessExcludeUname = "clamav";
        VirusEvent = "${notify-all-users}";
        User = "clamav";
        MaxDirectoryRecursion = 30;
      };
    };
    services.clamav.updater.enable = true;

    systemd.services.clamav-clamonacc = {
      description = "ClamAV daemon (clamonacc)";
      after = ["clamav-freshclam.service" "clamav-daemon.service"];
      requires = ["clamav-daemon.service"];
      wantedBy = ["multi-user.target"];
      restartTriggers = ["/etc/clamav/clamd.conf"];

      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
        ExecStart = "${pkgs.systemd}/bin/systemd-cat --identifier=av-scan ${pkgs.clamav}/bin/clamonacc -F --fdpass";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        PrivateNetwork = "yes";
        TimeoutStopSec = "5";
      };
    };

    #systemd.timers.av-user-scan = {
    #  description = "scan normal user directories for suspect files";
    #  wantedBy = ["timers.target"];
    #  timerConfig = {
    #    OnCalendar = "weekly";
    #    Unit = "av-user-scan.service";
    #  };
    #};

    systemd.services.av-user-scan = {
      description = "scan normal user directories for suspect files";
      after = ["network.target" "clamav-daemon.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemd-cat --identifier=av-scan ${pkgs.clamav}/bin/clamdscan --quiet --recursive --fdpass ${toString all-user-folders}";
      };
    };

    systemd.services.av-all-scan = {
      description = "scan all directories for suspect files";
      after = ["network.target" "clamav-daemon.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = ''
          ${pkgs.systemd}/bin/systemd-cat --identifier=av-scan ${pkgs.clamav}/bin/clamdscan --quiet --recursive --fdpass ${toString all-system-folders}
        '';
      };
    };
  };
}
