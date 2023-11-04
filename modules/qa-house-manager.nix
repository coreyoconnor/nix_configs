{ config, pkgs, lib, ... }:

with lib;
let
  unstableSrc = builtins.fetchGit {
    url = https://github.com/NixOS/nixpkgs.git;
    rev = "dc42e2603bc63e39865fbe91c2566182f5e70513";
    ref = "master";
  };
  unstable = import unstableSrc {
    config = {
      permittedInsecurePackages = [ "openssl-1.1.1w" ];
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

      extraComponents = [
    "accuweather"
    "advantage_air"
    "air_quality"
    "airly"
    "airnow"
    "airq"
    "airthings"
    "airthings_ble"
    "airtouch4"
    "alarm_control_panel"
    "alarmdecoder"
    "alert"
    "alexa"
    "ambiclimate"
    "ambient_station"
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
    "caldav"
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
    "directv"
    "discord"
    "dlna_dmr"
    "dlna_dms"
    "dnsip"
    "doorbird"
    "dormakaba_dkey"
    "dsmr"
    "dsmr_reader"
    "dte_energy_bridge"
    "duckdns"
    "dunehd"
    "eafm"
    "easyenergy"
    "ecobee"
    "econet"
    "ecowitt"
    "edl21"
    "efergy"
    "eight_sleep"
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
    "eufylife_ble"
    "everlights"
    "evil_genius_labs"
    "ezviz"
    "faa_delays"
    "facebook"
    "facebox"
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
    "fjaraskupan"
    "flic"
    "flick_electric"
    "flipr"
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
    "freedompro"
    "fritz"
    "fritzbox"
    "fritzbox_callmonitor"
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
    "geonetnz_quakes"
    "geonetnz_volcano"
    "gios"
    "github"
    "glances"
    "goalzero"
    "gogogate2"
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
    "gree"
    "greeneye_monitor"
    "group"
    "growatt_server"
    "guardian"
    "habitica"
    "hardkernel"
    "hardware"
    "harmony"
    "hassio"
    "hddtemp"
    "hdmi_cec"
    "heos"
    "here_travel_time"
    "hisense_aehw4a1"
    "history"
    "history_stats"
    "hive"
    "hlk_sw16"
    "home_connect"
    "home_plus_control"
    "homeassistant"
    "homeassistant_alerts"
    "homeassistant_hardware"
    "homeassistant_sky_connect"
    "homeassistant_yellow"
    "homekit"
    "homekit_controller"
    "homematic"
    "homematicip_cloud"
    "homewizard"
    "honeywell"
    "html5"
    "http"
    "huawei_lte"
    "hue"
    "huisbaasje"
    "humidifier"
    "hunterdouglas_powerview"
    "hvv_departures"
    "hyperion"
    "ialarm"
    "iaqualink"
    "ibeacon"
    "icloud"
    "ifttt"
    "ign_sismologia"
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
    "islamic_prayer_times"
    "isy994"
    "izone"
    "jellyfin"
    "jewish_calendar"
    "juicenet"
    "justnimbus"
    "kaleidescape"
    "keenetic_ndms2"
    "kegtron"
    "keymitt_ble"
    "kira"
    "kitchen_sink"
    "kmtronic"
    "knx"
    "kodi"
    "konnected"
    "kostal_plenticore"
    "kraken"
    "kulersky"
    "lametric"
    "landisgyr_heat_meter"
    "lastfm"
    "launch_library"
    "laundrify"
    "lcn"
    "ld2410_ble"
    "led_ble"
    "lg_soundbar"
    "lidarr"
    "life360"
    "lifx"
    "light"
    "litterrobot"
    "livisi"
    "local_calendar"
    "local_file"
    "local_ip"
    "locative"
    "lock"
    "logbook"
    "logentries"
    "logger"
    "logi_circle"
    "london_air"
    "lookin"
    "lovelace"
    "luftdaten"
    "lutron_caseta"
    "lyric"
    "mailbox"
    "mailgun"
    "manual"
    "manual_mqtt"
    "matter"
    "maxcube"
    "mazda"
    "meater"
    "media_player"
    "media_source"
    # "melcloud"
    "meraki"
    "met"
    "met_eireann"
    "meteo_france"
    "meteoclimatic"
    "metoffice"
    "microsoft_face"
    "microsoft_face_detect"
    "microsoft_face_identify"
    "mikrotik"
    "mill"
    "min_max"
    "minecraft_server"
    "minio"
    "mjpeg"
    "moat"
    "mobile_app"
    "modbus"
    "modem_callerid"
    "modern_forms"
    "mold_indicator"
    "moon"
    "mopeka"
    "motion_blinds"
    "motioneye"
    "mqtt"
    "mqtt_eventstream"
    "mqtt_json"
    "mqtt_room"
    "mqtt_statestream"
    "mullvad"
    "mutesync"
    "my"
    "myq"
    "mysensors"
    "mythicbeastsdns"
    "nam"
    "namecheapdns"
    "nanoleaf"
    "neato"
    "ness_alarm"
    "nest"
    "netatmo"
    "netgear"
    "network"
    "nexia"
    "nextbus"
    "nextcloud"
    "nextdns"
    "nfandroidtv"
    "nightscout"
    "nina"
    "nmap_tracker"
    "no_ip"
    "nobo_hub"
    "notify"
    "notify_events"
    "notion"
    "nuheat"
    "number"
    "nut"
    "nws"
    "obihai"
    "octoprint"
    "omnilogic"
    "onboarding"
    "oncue"
    "onewire"
    "onvif"
    "openai_conversation"
    "openalpr_cloud"
    "openerz"
    "openexchangerates"
    "opengarage"
    "openhardwaremonitor"
    "opentherm_gw"
    "openuv"
    "openweathermap"
    "opnsense"
    "oralb"
    "otbr"
    "overkiz"
    "ovo_energy"
    "owntracks"
    "p1_monitor"
    "panel_custom"
    "panel_iframe"
    "peco"
    "persistent_notification"
    "person"
    "philips_js"
    "pi_hole"
    "picnic"
    "ping"
    "plaato"
    "plant"
    "plex"
    "plugwise"
    "point"
    "poolsense"
    "powerwall"
    "profiler"
    "prometheus"
    "prosegur"
    "proximity"
    "prusalink"
    "pure_energie"
    "purpleair"
    "push"
    "pushbullet"
    "pushover"
    "pvoutput"
    "python_script"
    "qingping"
    "qld_bushfire"
    "qnap_qsw"
    "qwikswitch"
    "rachio"
    "radarr"
    "radio_browser"
    "radiotherm"
    "rainbird"
    "rainmachine"
    "random"
    "rapt_ble"
    "raspberry_pi"
    "rdw"
    "recollect_waste"
    "recorder"
    "remote"
    "repairs"
    "rest"
    "rest_command"
    "rflink"
    "rhasspy"
    "roon"
    "rpi_power"
    "rss_feed_template"
    "rtsp_to_webrtc"
    "safe_mode"
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
    "sigfox"
    "sighthound"
    "signal_messenger"
    "simplisafe"
    "simulated"
    "siren"
    "smappee"
    "smartthings"
    "smarttub"
    "smhi"
    "smtp"
    "snapcast"
    "snips"
    "snmp"
    "snooz"
    "solaredge"
    "solarlog"
    "solax"
    "soma"
    "sonarr"
    "songpal"
    "soundtouch"
    "spaceapi"
    "spc"
    "speedtestdotnet"
    "spider"
    "spotify"
    "sql"
    "srp_energy"
    "ssdp"
    "starline"
    "startca"
    "statistics"
    "statsd"
    "steam_online"
    "steamist"
    "stream"
    "stt"
    "subaru"
    "sun"
    "surepetcare"
    "switch"
    "switch_as_x"
    "switchbee"
    "switchbot"
    "switcher_kis"
    "syncthing"
    "syncthru"
    "synology_dsm"
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
    "thermobeacon"
    "thermopro"
    "thread"
    "threshold"
    "tile"
    "tilt_ble"
    "time_date"
    "timer"
    "tod"
    "todoist"
    "tolo"
    "tomato"
    "tomorrowio"
    "toon"
    "totalconnect"
    "tplink"
    "tplink_omada"
    "traccar"
    "trace"
    "tractive"
    "transmission"
    "transport_nsw"
    "trend"
    "tts"
    "tuya"
    "twilio"
    "twitch"
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
    "volvooncall"
    "vulcan"
    "vultr"
    "wake_on_lan"
    "wallbox"
    "water_heater"
    "watttime"
    "waze_travel_time"
    "weather"
    "webhook"
    "webostv"
    "websocket_api"
    "wemo"
    "whirlpool"
    "whois"
    "wiffi"
    "wilight"
    "withings"
    "wiz"
    "wled"
    "workday"
    "worldclock"
    "wsdot"
    "xbox"
    "yale_smart_alarm"
    "yalexs_ble"
    "yamaha"
    "yamaha_musiccast"
    "yeelight"
    "yolink"
    "youless"
    "zamg"
    "zeroconf"
    "zerproc"
    "zha"
    "zodiac"
    "zone"
    "zwave_js"
    "zwave_me"
  ];

      openFirewall = true;

      package = (pkgs.home-assistant.override {
        extraPackages = py: [
          py.cloudscraper
          py.psycopg2
          py.grpcio
          py.unidecode
          # (py.callPackage ./pyaarlo.nix { })
        ];

        packageOverrides = python-self: python-super: {
          asynctest = null;
          debugpy = null;
          mox3 = null;
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

    systemd.services.postgresql.serviceConfig.TimeoutSec = lib.mkOverride 10 666;
  };
}
