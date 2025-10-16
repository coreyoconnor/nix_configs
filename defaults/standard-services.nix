{
  options,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    programs.dconf.enable = mkDefault true;

    services = {
      acpid.enable = mkDefault true;
      dbus.enable = mkDefault true;
      fstrim.enable = mkDefault true;
      fwupd.enable = mkDefault true;
      openssh.enable = mkDefault true;
      udisks2.enable = mkDefault true;
      upower.enable = mkDefault true;
    };
  };
}
