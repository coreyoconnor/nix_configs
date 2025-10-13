{
  config,
  pkgs,
  lib,
  ...
}:
with lib; rec {
  config = {
    nix = {
      settings = {
        trusted-users = ["nix" "@wheel"];
      };
    };

    services = {
      syslogd.extraConfig = ''
        user.* /var/log/user
      '';
    };
  };
}
