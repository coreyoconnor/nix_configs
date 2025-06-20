{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib;
let
  nixpkgs-unstable-pkgs = nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  options.services.qa-house-manager = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  disabledModules = [
    "services/home-automation/home-assistant.nix"
  ];

  imports = [
    "${nixpkgs-unstable}/nixos/modules/services/home-automation/home-assistant.nix"
  ];

  config = mkIf config.services.qa-house-manager.enable {
    services.mosquitto = {
      enable = true;
      listeners = [
        {
          acl = ["pattern readwrite #"];
          omitPasswordAuth = true;
          settings.allow_anonymous = true;
        }
      ];
    };

    services.home-assistant = import ./qa-house-manager/home-assistant-service.nix {
      inherit config lib;
      pkgs = nixpkgs-unstable-pkgs;
    };

    # MQTT and postgresql
    networking.firewall.allowedTCPPorts = [1883 5432];

    nixpkgs = {
      config.permittedInsecurePackages = [
        "openssl-1.1.1w"
      ];
      overlays = [
        (self: super: {
          inherit (nixpkgs-unstable-pkgs) home-assistant;
        })
      ];
    };

    services.postgresql = {
      authentication = ''
        host all all 192.168.88.0/24 trust
        host all all 10.42.0.0/24 trust
        host all all 168.254.0.0/16 trust
      '';
      dataDir = "/var/lib/postgresql/14";
      enable = true;
      enableTCPIP = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
      package = pkgs.postgresql_14;
    };

    virtualisation.oci-containers.containers = {
      # https://github.com/tsightler/ring-mqtt-ha-addon/blob/main/config.yaml
      ring-mqtt = {
        image = "tsightler/ring-mqtt:5.8.1";
        autoStart = true;
        user = "286:286";
        volumes = [
          "/mnt/storage/hass/ring-mqtt:/data"
        ];
      };
    };

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;

    services.matter-server.enable = true;
  };
}
