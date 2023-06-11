{ config, pkgs, lib, ... }:

with lib;
let
  unstableSrc = builtins.fetchGit {
    url = https://github.com/NixOS/nixpkgs.git;
    rev = "d5210941a5003a865421bd50bbd0a43a2d511bcf";
    ref = "master";
  };
  unstable = import unstableSrc {
    config = {
      permittedInsecurePackages = [ "openssl-1.1.1u" ];
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "python-nest"
      ];
    };

    overlays = [
    ];
  };
in {
  disabledModules = [
    "services/home-automation/home-assistant.nix"
  ];

  imports = [
    "${unstableSrc}/nixos/modules/services/home-automation/home-assistant.nix"
  ];

  options.services.qa-house-manager = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.services.qa-house-manager.enable {
    networking.enableIPv6 = false;

    nixpkgs.overlays = [
      (self: super: {
        inherit (unstable) home-assistant;
      })
    ];

    services.mosquitto = {
      enable = true;
      listeners = [ {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      } ];
    };

    services.home-assistant = {
      enable = true;

      config = {
        aarlo = {
          username = "!secret arlo_username";
          password = "!secret arlo_password";
          tfa_source = "imap";
          tfa_type = "email";
          tfa_host = "!secret arlo_imap_host";
          tfa_username = "!secret arlo_imap_username";
          tfa_password = "!secret arlo_imap_password";

          refresh_devices_every = 2;
          stream_timeout = 120;

          save_updates_to = "/var/lib/hass/arlo/updates";
          save_media_to = "/var/lib/hass/arlo/media/\${SN}/\${Y}/\${m}/\${d}/\${T}";
          mqtt_host = "mqtt-cluster-z1.arloxcld.com";
        };

        binary_sensor = [
          {
            platform = "aarlo";

            monitored_conditions = [
              "motion"
              "sound"
              "connectivity"
            ];
          }
        ];

        camera = [
          {
            platform = "aarlo";
          }
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
            "/mnt/storage/hass/arlo/updates"
            "/mnt/storage/hass/arlo/media"
          ];
          name = "Home";
          country = "US";
          latitude = "!secret home_latitude";
          longitude = "!secret home_longitude";
          elevation  = "!secret home_elevation";
          time_zone = config.time.timeZone;
          unit_system = "imperial";
          auth_providers = [
            {
              type = "trusted_networks";
              trusted_networks = [
                # lan network
                "192.168.86.0/24"
                "127.0.0.1"
              ];
              allow_bypass_login = true;
            }
            {
              type = "homeassistant";
            }
          ];

          media_dirs = {
            cameras = "/mnt/storage/hass/arlo/media";
          };
        };

        logger = {
          default = "info";
          logs = {
          };
        };

        lovelace = { };

        media_player = [
          { platform = "aarlo"; }
        ];

        mobile_app = { };

        mqtt = {};

        recorder = {
          db_url = "postgresql://@/hass";
          purge_keep_days = 800;
        };

        sensor = [
          {
            platform = "aarlo";
            monitored_conditions = [
              "total_cameras"
              "last_capture"
              "recent_activity"
              "captured_today"
              "battery_level"
              "signal_strength"
            ];
          }
        ];

        stream = {};

        system_health = { };

        template = [
          {
            sensor = [
              {
                name = "BigLevoit Fan Level";
                unit_of_measurement = "%";
                state = "{{ state_attr('fan.biglevoit', 'percentage') | int(0) }}";
              }
            ];
          }
          {
            binary_sensor = [
              {
                name = "Central Fan";
                state = "{{ state_attr('climate.den', 'fan_mode') }}";
              }
            ];
          }
        ];

        tts = [{
          platform = "picotts";
        }];

        zeroconf = { };
      };

      extraComponents = pkgs.home-assistant.supportedComponentsWithTests;

      openFirewall = true;

      package = (pkgs.home-assistant.override {
        python311 = unstable.python310;

        extraPackages = py: [
          py.cloudscraper
          py.psycopg2
          py.grpcio
          py.unidecode
          # (py.callPackage ./pyaarlo.nix { })
        ];

        #packageOverrides = python-self: python-super: {
        #  numpy = python-super.numpy.overridePythonAttrs (oldAttrs: {
        #    setupPyBuildFlags = [ "--cpu-baseline=\"avx f16c\"" ];
        #  });
        #  dask = python-super.dask.overridePythonAttrs (oldAttrs: {
        #    # doCheck = false;
        #  });
        #  pydaikin = python-super.pydaikin.overridePythonAttrs (oldAttrs: {
        #    doCheck = false;
        #  });
        #};
      }).overrideAttrs (oldAttrs: {
        doInstallCheck = false;
      });
    };

    # MQTT
    networking.firewall.allowedTCPPorts = [ 1883 ];

    services.postgresql = {
      dataDir = "/mnt/storage/postgresql/14";
      enable = true;
      ensureDatabases = [ "hass" ];
      ensureUsers = [{
        name = "hass";
        ensurePermissions = {
          "DATABASE hass" = "ALL PRIVILEGES";
        };
      }];
    };

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;
  };
}
