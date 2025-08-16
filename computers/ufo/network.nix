{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../network/home
    ../../network/home/resource-media-server.nix
  ];
  config = {
    networking = {
      hostId = "abab4ab2";
      hostName = "ufo";
      useDHCP = true;
    };
    services.avahi = {
      denyInterfaces = [ "eno1" "eno2" ];
    };

    services.resolved.enable = true;

    services.kubo.settings = {
      Addresses.API = "192.168.88.4";
    };

    services.nix-serve = {
      port = 4999;
      openFirewall = true;
      bindAddress = "192.168.88.4";
    };

    services.cloudflared = {
      enable = true;
      tunnels = {
        "uswest-0" = {
          credentialsFile = "/root/secrets/cloudflared-uswest-0-creds.json";
          default = "http_status:404";
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [9191];
    };
  };
}
