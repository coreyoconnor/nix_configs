{ config, pkgs, lib, ... }:

with lib;
let
  unstableSrc = builtins.fetchGit {
    url = https://github.com/NixOS/nixpkgs.git;
    rev = "4a1b19a0524ed640f69a0e4d1ff8ca96e1f9bba9";
    ref = "master";
  };
  unstable = import unstableSrc {
    config = {
      permittedInsecurePackages = [ "openssl-1.1.1v" ];
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
    "abode"
    "accuweather"
    "acmeda"
    "adax"
    "adguard"
    "advantage_air"
    "aemet"
    "agent_dvr"
    "air_quality"
    "airly"
    "airnow"
    "airq"
    "airthings"
    "airthings_ble"
    "airtouch4"
    "airvisual"
    "airvisual_pro"
    "airzone"
    "aladdin_connect"
    "alarm_control_panel"
    "alarmdecoder"
    "alert"
    "alexa"
    "amberelectric"
    "ambiclimate"
    "ambient_station"
    "analytics"
    "android_ip_webcam"
    "androidtv"
    "apache_kafka"
    "apcupsd"
    "api"
    "apple_tv"
    "application_credentials"
    "apprise"
    # "aprs"
    "aranet"
    "arcam_fmj"
    "aseko_pool_live"
    "assist_pipeline"
    "asuswrt"
    "atag"
    "august"
    "aurora"
    "aurora_abb_powerone"
    "aussie_broadband"
    "auth"
    "automation"
    "awair"
    "aws"
    "axis"
    "azure_devops"
    "azure_event_hub"
    "backup"
    "balboa"
    "bayesian"
    "binary_sensor"
    "blackbird"
    "blebox"
    "blink"
    "bluemaestro"
    "blueprint"
    "bluetooth"
    "bluetooth_adapters"
    "bluetooth_le_tracker"
    "bmw_connected_drive"
    "bond"
    "bosch_shc"
    "braviatv"
    "broadlink"
    "brother"
    "brottsplatskartan"
    "brunt"
    "bsblan"
    "bthome"
    "buienradar"
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
    "comfoconnect"
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
    "crownstone"
    "daikin"
    "datadog"
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
    "devolo_home_control"
    "devolo_home_network"
    "dexcom"
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
    "dynalite"
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
    "nibe_heatpump"
    "nightscout"
    "nina"
    "nmap_tracker"
    "no_ip"
    "nobo_hub"
    "notify"
    "notify_events"
    "notion"
    "nsw_rural_fire_service_feed"
    "nuheat"
    "nuki"
    "number"
    "nut"
    "nws"
    "nx584"
    "obihai"
    "octoprint"
    "omnilogic"
    "onboarding"
    "oncue"
    "ondilo_ico"
    "onewire"
    "onvif"
    "open_meteo"
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
    "panasonic_viera"
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
    "pvpc_hourly_pricing"
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
    "rainforest_eagle"
    "rainmachine"
    "random"
    "rapt_ble"
    "raspberry_pi"
    "rdw"
    "recollect_waste"
    "recorder"
    "reddit"
    "remote"
    "renault"
    "reolink"
    "repairs"
    "rest"
    "rest_command"
    "rflink"
    "rfxtrx"
    "rhasspy"
    "ridwell"
    "ring"
    "risco"
    "rituals_perfume_genie"
    "rmvtransport"
    "roborock"
    "roku"
    "roomba"
    "roon"
    "rpi_power"
    "rss_feed_template"
    "rtsp_to_webrtc"
    "ruckus_unleashed"
    "ruuvi_gateway"
    "ruuvitag_ble"
    "sabnzbd"
    "safe_mode"
    "samsungtv"
    "scene"
    "schedule"
    "scrape"
    "screenlogic"
    "script"
    "search"
    "season"
    "select"
    "sense"
    "sensibo"
    "sensor"
    "sensorpro"
    "sensorpush"
    "sentry"
    "senz"
    "seventeentrack"
    "sfr_box"
    "sharkiq"
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
    "skybell"
    "slack"
    "sleepiq"
    "slimproto"
    "sma"
    "smappee"
    "smart_meter_texas"
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
    "somfy_mylink"
    "sonarr"
    "songpal"
    "sonos"
    "soundtouch"
    "spaceapi"
    "spc"
    "speedtestdotnet"
    "spider"
    "spotify"
    "sql"
    "squeezebox"
    "srp_energy"
    "ssdp"
    "starline"
    "startca"
    "statistics"
    "statsd"
    "steam_online"
    "steamist"
    "stookalert"
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
    "telegram"
    "telegram_bot"
    "tellduslive"
    "temper"
    "template"
    "tesla_wall_connector"
    "text"
    "thermobeacon"
    "thermopro"
    "thread"
    "threshold"
    "tibber"
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
    "tradfri"
    "trafikverket_ferry"
    "trafikverket_train"
    "trafikverket_weatherstation"
    "transmission"
    "transport_nsw"
    "trend"
    "tts"
    "tuya"
    "twentemilieu"
    "twilio"
    "twinkly"
    "twitch"
    "uk_transport"
    "ukraine_alarm"
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
    "ws66i"
    "wsdot"
    "xbox"
    "xiaomi"
    "xiaomi_aqara"
    "xiaomi_ble"
    "xiaomi_miio"
    "yale_smart_alarm"
    "yalexs_ble"
    "yamaha"
    "yamaha_musiccast"
    "yandex_transport"
    "yandextts"
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
