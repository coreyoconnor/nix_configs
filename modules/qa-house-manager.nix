{
  config,
  pkgs,
  nixpkgs-unstable,
  lib,
  ...
}:
with lib; let
  unstable = import nixpkgs-unstable {
    system = pkgs.system;

    config = {
      permittedInsecurePackages = ["openssl-1.1.1w"];
      allowUnfree = true;
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "python-nest"
          "python3.11-pyasyncore-1.0.2"
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
    "${nixpkgs-unstable}/nixos/modules/services/home-automation/home-assistant.nix"
  ];

  options.services.qa-house-manager = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.services.qa-house-manager.enable {
    nixpkgs.overlays = [
      (self: super: {
        inherit (unstable) home-assistant;
      })
    ];

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
          {platform = "aarlo";}
        ];

        mobile_app = {};

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
          {
            platform = "picotts";
          }
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
        #"caldav"
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
        "denonavr"
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
        "doorbird"
        "dormakaba_dkey"
        "dsmr"
        "dsmr_reader"
        "ecobee"
        "econet"
        "ecowitt"
        "edl21"
        "efergy"
        "elgato"
        "elkm1"
        "elmax"
        "emonitor"
        "emulated_hue"
        "emulated_kasa"
        "emulated_roku"
        "energy"
        "energyzero"
        "enocean"
        "enphase_envoy"
        "environment_canada"
        "epson"
        "escea"
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
        "fireservicerota"
        "firmata"
        "fivem"
        "flo"
        "flume"
        "flux"
        "flux_led"
        "folder"
        "folder_watcher"
        "foobot"
        "forecast_solar"
        "foscam"
        "freebox"
        "freedns"
        "fronius"
        "frontend"
        "frontier_silicon"
        "fully_kiosk"
        "garages_amsterdam"
        "gdacs"
        "generic"
        "generic_hygrostat"
        "generic_thermostat"
        "geo_json_events"
        "geo_location"
        "geo_rss_events"
        "geocaching"
        "geofency"
        "gios"
        "github"
        "glances"
        "goalzero"
        "goodwe"
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
        "govee_ble"
        "gpslogger"
        "graphite"
        "group"
        "guardian"
        "habitica"
        "hardware"
        "harmony"
        "hassio"
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
        "hyperion"
        "image_processing"
        "image_upload"
        "influxdb"
        "inkbird"
        "input_boolean"
        "input_button"
        "input_datetime"
        "input_number"
        "input_select"
        "input_text"
        "insteon"
        "integration"
        # "intellifire"
        "intent"
        "intent_script"
        "ios"
        "iotawatt"
        "ipma"
        "ipp"
        "iqvia"
        "isy994"
        "izone"
        "kitchen_sink"
        "launch_library"
        "laundrify"
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
        "logi_circle"
        "lookin"
        "lovelace"
        "mailbox"
        "mailgun"
        "manual"
        "manual_mqtt"
        "matter"
        "media_player"
        "media_source"
        "meraki"
        "met"
        "met_eireann"
        "meteo_france"
        "meteoclimatic"
        "mikrotik"
        "mill"
        "min_max"
        "minio"
        "mjpeg"
        "moat"
        "mobile_app"
        "modbus"
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
        "notion"
        "number"
        "nut"
        "nws"
        "obihai"
        "octoprint"
        "omnilogic"
        "onboarding"
        "oncue"
        "openai_conversation"
        "openalpr_cloud"
        "openerz"
        "openhardwaremonitor"
        "openuv"
        "openweathermap"
        "panel_custom"
        "panel_iframe"
        "peco"
        "persistent_notification"
        "person"
        "picnic"
        "ping"
        "plant"
        "plugwise"
        "point"
        "profiler"
        "prometheus"
        "proximity"
        "push"
        "pushover"
        "pvoutput"
        "python_script"
        "qnap_qsw"
        "rachio"
        "radarr"
        "radio_browser"
        "radiotherm"
        "rainbird"
        "rainmachine"
        "random"
        "rapt_ble"
        "rdw"
        "recorder"
        "remote"
        "repairs"
        "rest"
        "rest_command"
        "rflink"
        "roon"
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
        "sonarr"
        "songpal"
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
        "tado"
        "tag"
        "tailscale"
        "tankerkoenig"
        "tasmota"
        "tautulli"
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
        "transport_nsw"
        "trend"
        "tts"
        "tuya"
        "unifi"
        "unifi_direct"
        "unifiprotect"
        "universal"
        "upb"
        "upcloud"
        "update"
        "upnp"
        "uptime"
        "uptimerobot"
        "usb"
        "usgs_earthquakes_feed"
        "utility_meter"
        "uvc"
        "vacuum"
        "vallox"
        "velbus"
        "venstar"
        "vera"
        "verisure"
        "version"
        "vesync"
        "vicare"
        "vilfo"
        "vizio"
        "vlc_telnet"
        "voicerss"
        "volumio"
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
        "wemo"
        "whois"
        "wiffi"
        "wilight"
        "withings"
        "wiz"
        "wled"
        "workday"
        "worldclock"
        "wsdot"
        "zamg"
        "zeroconf"
        "zone"
      ];

      openFirewall = true;

      package =
        (pkgs.home-assistant.override {
          extraPackages = py: [
            py.cloudscraper
            py.psycopg2
            py.grpcio
            py.unidecode
            (py.callPackage ./pyaarlo.nix { })
          ];

          packageOverrides = python-self: python-super: {
            asynctest = null;
            debugpy = null;
            mox3 = null;
            bellows = python-super.bellows.overridePythonAttrs (_: {
              doCheck = false;
            });
          };
        })
        .overrideAttrs (oldAttrs: {
          doInstallCheck = false;
        });
    };

    # MQTT
    networking.firewall.allowedTCPPorts = [1883];

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
