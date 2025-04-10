{ config, lib, pkgs, ... }:
with lib; let
  kleenex_pollenradar = pkgs.buildHomeAssistantComponent {
    owner = "MarcoGos";
    domain = "kleenex_pollenradar";
    version = "1.1.7";

    src = pkgs.fetchFromGitHub {
      owner = "MarcoGos";
      repo = "kleenex_pollenradar";
      rev = "03656e80cb33007f15741c167a7d84d721d13e0e";
      hash = "sha256-k7Iq69la44hoAQpuJ6TqAs9SG1kAW+zs1TtoaJvIrEM=";
    };

    propagatedBuildInputs = with pkgs.home-assistant.python.pkgs; [
      beautifulsoup4
    ];

    patches = [ ./kleenex_pollenradar.diff ];
  };

in {
  enable = true;

  lovelaceConfig = import ./lovelace-config.nix;

  config = {
    "automation ui" = "!include automations.yaml";

    binary_sensor = [
    ];

    camera = [
    ];

    # Includes dependencies for a basic setup
    # https://www.home-assistant.io/integrations/default_config/
    default_config = {};

    ffmpeg = {};

    homeassistant = {
      allowlist_external_dirs = [
        "/tmp"
        "/var/lib/hass/arlo/updates"
        "/var/lib/hass/arlo/media"
        "/mnt/storage/hass/arlo/media"
        "/mnt/storage/hass/arlo/updates"
      ];
      name = "Home";
      country = "US";
      latitude = "!secret home_latitude";
      longitude = "!secret home_longitude";
      elevation = "!secret home_elevation";
      radius = "100";
      time_zone = config.time.timeZone;
      unit_system = "us_customary";
      auth_providers = [
        {
          type = "trusted_networks";
          trusted_networks = [
            # lan network
            "192.168.88.0/24"
            "127.0.0.1"
          ];
          allow_bypass_login = false;
        }
        {
          type = "homeassistant";
        }
      ];

      media_dirs = {
        cameras = "/var/lib/hass/arlo/media";
      };
    };

    logger = {
      default = "info";
      logs = {};
    };

    media_player = [
    ];

    mobile_app = {};

    mqtt = {};

    recorder = {
      db_url = "postgresql://@/hass";
      purge_keep_days = 800;
    };

    sensor = [
    ];

    stream = {};

    system_health = {};

    template = [
    ];

    tts = [
      #{
      #  platform = "picotts";
      #}
    ];

    zeroconf = {};
  };

  extraComponents = import ./extra-components.nix { inherit config lib pkgs; };

  openFirewall = true;

  customComponents = [
    kleenex_pollenradar
  ];

  customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
    card-mod
    apexcharts-card
    mini-graph-card
    lg-webos-remote-control
    mushroom
  ];

  extraPackages = ps:
    with ps; [
      cloudscraper
      psycopg2
      grpcio
      unidecode
    ];
}
