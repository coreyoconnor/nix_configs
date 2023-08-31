{ config, pkgs, lib, ... }:
let notify-all-users = pkgs.writeScript "notify-all-users-of-virus"
  ''
    #!/bin/sh
    ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"
    # Send an alert to all graphical users.
    for ADDRESS in /run/user/*; do
        USERID=''${ADDRESS#/run/user/}
       /run/wrappers/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" ${pkgs.libnotify}/bin/notify-send -i dialog-warning "Virus found!" "$ALERT"
    done
  '';
in with lib; {
  config = {
    environment.systemPackages = with pkgs; [
      acpi
      cryptsetup
      fzf
      jq
      htop
      neovim
      nix-index
      pciutils
      pcre
      screen
      tmux
      usbutils
    ];

    environment.variables.EDITOR = mkOverride 950 "${pkgs.neovim}/bin/nvim";

    security.sudo = {
      enable = true;
      extraConfig  =
      ''
        clamav ALL = (ALL) NOPASSWD: SETENV: ${pkgs.libnotify}/bin/notify-send
      '';
      wheelNeedsPassword = false;
    };

    security.forcePageTableIsolation = true;
    security.virtualisation.flushL1DataCache = "cond";

    services.openssh.enable = true;
    services.clamav.daemon = {
      enable = true;

      settings = {
        OnAccessIncludePath = [ "/home/coconnor/Downloads" "/home/coconnor/.mozilla"];
        OnAccessPrevention = false;
        OnAccessExtraScanning = true;
        OnAccessExcludeUname =  "clamav";
        VirusEvent = "${notify-all-users}";
        User = "clamav";
      };
    };
    services.clamav.updater.enable = true;

    systemd.services.clamav-clamonacc = {
      description = "ClamAV daemon (clamonacc)";
      after = [ "clamav-freshclam.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ "/etc/clamav/clamd.conf" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.clamav}/bin/clamonacc -F --fdpass";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        PrivateNetwork = "yes";
      };
    };
  };
}
