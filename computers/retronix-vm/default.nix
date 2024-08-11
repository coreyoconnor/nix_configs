{
  config,
  lib,
  pkgs,
  retronix,
  ...
}:
with lib; {
  imports = [
    ../../domains/primary
    retronix.nixosModules.default
  ];

  config = {
    networking.hostName = "retronix-vm";

    users.users.media.password = "media";

    retronix = {
      enable = true;
      # steamLauncher = true;
      nick = "UFO";
      user = "media";
    };
  };
}
