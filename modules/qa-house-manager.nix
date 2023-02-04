{ config, pkgs, lib, ... }:

with lib;
let
  unstableSrc = builtins.fetchGit {
    url = https://github.com/NixOS/nixpkgs.git;
    rev = "06999209d7a0043d4372e38f57cffae00223d592";
    ref = "nixos-unstable";
  };
  unstable = import unstableSrc {
    overlays = [ ];
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
          latitude = 47.628099;
          longitude = -122.359694;
          elevation = 116;
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
      };

      extraComponents = pkgs.home-assistant.supportedComponentsWithTests;

      openFirewall = true;

      package = (pkgs.home-assistant.override {
        extraPackages = py: with py; [
          psycopg2
          (py.callPackage ./pyaarlo.nix { })
        ];

        packageOverrides = python-self: python-super: {
          numpy = python-super.numpy.overridePythonAttrs (oldAttrs: {
            setupPyBuildFlags = [ "--cpu-baseline=\"avx f16c\"" ];
          });
          dask = python-super.dask.overridePythonAttrs (oldAttrs: {
            # doCheck = false;
          });
          pydaikin = python-super.pydaikin.overridePythonAttrs (oldAttrs: {
            doCheck = false;
          });
        };
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
  };
}
