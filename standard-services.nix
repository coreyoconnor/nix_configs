{config, pkgs, lib, ...}:
with lib;
{
  config =
  {
    boot.blacklistedKernelModules = [ "snd_pcsp" ];

    nix =
    {
      gc =
      {
        automatic = true;
        options = "--delete-older-than 30d";
      };

      optimise.automatic = true;
    };

    programs.mosh.enable = true;

    services =
    {
      dbus =
      {
        enable = true;
        socketActivated = true;
      };
      ntp.enable = true;
      udisks2.enable = true;
      upower.enable = true;
      acpid.enable = true;
      openssh =
      {
        enable = true;
      };
      nixosManual.showManual = true;

      syslogd.extraConfig = ''
          user.* /var/log/user
      '';

      xfs.enable = false;
    };

    sound.enable = true;
  };
}
