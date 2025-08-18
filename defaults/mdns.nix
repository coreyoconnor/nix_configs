{
  options,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    services.resolved = {
      enable = true;
      domains = [ "local" ];
      llmnr = "false";
      extraConfig = ''
        MulticaseDNS=yes
      '';
    };

    networking.firewall = {
      allowedUDPPorts = [5353];
    };

    services.avahi.enable = false;
  };
}

