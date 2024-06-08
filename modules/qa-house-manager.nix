{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib; {
  options.services.qa-house-manager = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

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
        };

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
            cameras = "/var/lib/hass/arlo/media";
          };
        };

        logger = {
          default = "info";
          logs = {};
        };

        lovelace = {};

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

        tts = [
          #{
          #  platform = "picotts";
          #}
        ];

        zeroconf = {};
      };

      extraComponents = [
        "accuweather"
        "advantage_air"
        "air_quality"
        "airly"
        "airnow"
        "airthings"
        "airthings_ble"
        "alert"
        "alexa"
        "analytics"
        "apache_kafka"
        "apcupsd"
        "api"
        "apple_tv"
        "application_credentials"
        "assist_pipeline"
        "asuswrt"
        "auth"
        "automation"
        "backup"
        "bayesian"
        "binary_sensor"
        "blackbird"
        "blebox"
        "blink"
        "blueprint"
        "bluetooth"
        "bluetooth_adapters"
        "bluetooth_le_tracker"
        "bond"
        "broadlink"
        "brother"
        "button"
        "calendar"
        "camera"
        "canary"
        "cast"
        "cert_expiry"
        "clicksend_tts"
        "climate"
        "cloud"
        "cloudflare"
        "co2signal"
        "color_extractor"
        "command_line"
        "compensation"
        "config"
        "configurator"
        "control4"
        "conversation"
        "coolmaster"
        "counter"
        "cover"
        "cpuspeed"
        "debugpy"
        "deconz"
        "default_config"
        "deluge"
        "demo"
        "derivative"
        "device_automation"
        "device_sun_light_trigger"
        "device_tracker"
        "dhcp"
        "diagnostics"
        "dialogflow"
        "discord"
        "dlna_dmr"
        "dlna_dms"
        "dnsip"
        "dsmr"
        "dsmr_reader"
        "energy"
        "esphome"
        "faa_delays"
        "fail2ban"
        "fan"
        "feedreader"
        "ffmpeg"
        "fibaro"
        "fido"
        "file"
        "file_upload"
        "filesize"
        "filter"
        "fivem"
        "folder"
        "folder_watcher"
        "forecast_solar"
        "frontend"
        "gdacs"
        "generic"
        "generic_hygrostat"
        "generic_thermostat"
        "geo_json_events"
        "geo_location"
        "geo_rss_events"
        "geocaching"
        "github"
        "glances"
        "google"
        "google_assistant"
        "google_assistant_sdk"
        "google_domains"
        "google_mail"
        "google_pubsub"
        "google_sheets"
        "google_translate"
        "google_travel_time"
        "google_wifi"
        "gpslogger"
        "graphite"
        "group"
        "guardian"
        "habitica"
        "hardware"
        "hddtemp"
        "hdmi_cec"
        "history"
        "history_stats"
        "hive"
        "home_connect"
        "home_plus_control"
        "homeassistant"
        "homeassistant_alerts"
        "homeassistant_hardware"
        "homeassistant_sky_connect"
        "homeassistant_yellow"
        "homekit"
        "homekit_controller"
        "html5"
        "http"
        "hue"
        "humidifier"
        "image_processing"
        "image_upload"
        "influxdb"
        "input_boolean"
        "input_button"
        "input_datetime"
        "input_number"
        "input_select"
        "input_text"
        "insteon"
        "integration"
        "intent"
        "intent_script"
        "ios"
        "iotawatt"
        "ipma"
        "ipp"
        "kitchen_sink"
        "launch_library"
        "lcn"
        "light"
        "local_calendar"
        "local_file"
        "local_ip"
        "locative"
        "lock"
        "logbook"
        "logentries"
        "logger"
        "lookin"
        "lovelace"
        "mailbox"
        "mailgun"
        "manual"
        "manual_mqtt"
        "matter"
        "media_player"
        "media_source"
        "met"
        "mill"
        "min_max"
        "minio"
        "mjpeg"
        "moat"
        "mobile_app"
        "modern_forms"
        "mold_indicator"
        "moon"
        "mqtt"
        "mqtt_eventstream"
        "mqtt_json"
        "mqtt_room"
        "mqtt_statestream"
        "my"
        "mysensors"
        "nest"
        "network"
        "nmap_tracker"
        "no_ip"
        "notify"
        "notify_events"
        "number"
        "nut"
        "octoprint"
        "onboarding"
        "openai_conversation"
        "openhardwaremonitor"
        "openuv"
        "openweathermap"
        "panel_custom"
        "panel_iframe"
        "persistent_notification"
        "person"
        "picnic"
        "ping"
        "plant"
        "point"
        "profiler"
        "prometheus"
        "proximity"
        "push"
        "pushover"
        "pvoutput"
        "python_script"
        "rachio"
        "radarr"
        "radio_browser"
        "radiotherm"
        "random"
        "rdw"
        "recorder"
        "remote"
        "repairs"
        "rest"
        "rest_command"
        "rflink"
        "rpi_power"
        "rss_feed_template"
        "rtsp_to_webrtc"
        "scene"
        "schedule"
        "scrape"
        "screenlogic"
        "script"
        "search"
        "season"
        "select"
        "sense"
        "sensor"
        "sensorpro"
        "sensorpush"
        "sentry"
        "shell_command"
        "shelly"
        "shopping_list"
        "sia"
        "sighthound"
        "simulated"
        "siren"
        "smartthings"
        "smhi"
        "smtp"
        "snips"
        "snmp"
        "soma"
        "soundtouch"
        "spaceapi"
        "spotify"
        "spc"
        "sql"
        "srp_energy"
        "ssdp"
        "statistics"
        "statsd"
        "stream"
        "stt"
        "sun"
        "switch"
        "switch_as_x"
        "switchbee"
        "switchbot"
        "switcher_kis"
        "syncthing"
        "syncthru"
        "system_health"
        "system_log"
        "systemmonitor"
        "tado"
        "tag"
        "tailscale"
        "tasmota"
        "tcp"
        "temper"
        "template"
        "text"
        "thread"
        "threshold"
        "time_date"
        "timer"
        "tod"
        "tomato"
        "tomorrowio"
        "toon"
        "totalconnect"
        "trace"
        "transmission"
        "trend"
        "tts"
        "tuya"
        "universal"
        "upb"
        "update"
        "upnp"
        "uptime"
        "uptimerobot"
        "usb"
        "usgs_earthquakes_feed"
        "utility_meter"
        "uvc"
        "vacuum"
        "verisure"
        "version"
        "vesync"
        "vicare"
        "vilfo"
        "vizio"
        "vlc_telnet"
        "voicerss"
        "vulcan"
        "vultr"
        "wake_on_lan"
        "wallbox"
        "water_heater"
        "watttime"
        "weather"
        "webhook"
        "webostv"
        "websocket_api"
        "whois"
        "withings"
        "wled"
        "workday"
        "worldclock"
        "wsdot"
        "zeroconf"
        "zone"
      ];

      openFirewall = true;

      customComponents = [
        (pkgs.fetchFromGitHub {
          owner = "MarcoGos";
          repo = "kleenex_pollenradar";
          rev = "a4840fdf9bffe7adf1b1f2a1b7ca84d864357be1";
          hash = "sha256-0yvJSE/c9DwY6kcaJQZIsGtQtAqwmwe3Ww9zm9bcHHc=";
        })
      ];

      customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
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
          (callPackage ./pyaarlo.nix {})
        ];
    };

    # MQTT
    networking.firewall.allowedTCPPorts = [1883];

    nixpkgs.config.permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];

    services.postgresql = {
      dataDir = "/var/lib/postgresql/14";
      enable = true;
      ensureDatabases = ["hass"];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
      package = pkgs.postgresql_14;
    };

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;
  };
}
