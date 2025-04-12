{
  title = "Home";
  views = [
    {
      title = "Home";
      sections = [
        {
          type = "grid";
          cards = [
            {
              type = "heading";
              heading = "Weather";
              heading_style = "title";
              tap_action = {
                action = "navigate";
                navigation_path = "/lovelace-environment";
              };
              grid_options = {
                columns = "full";
                rows = 1;
              };
            }
            {
              type = "weather-forecast";
              entity = "weather.tomorrow_io_home_daily";
              show_forecast = false;
            }
            {
              show_current = false;
              show_forecast = true;
              type = "weather-forecast";
              entity = "weather.tomorrow_io_home_daily";
              forecast_type = "hourly";
            }
            {
              show_current = false;
              show_forecast = true;
              type = "weather-forecast";
              entity = "weather.tomorrow_io_home_daily";
              forecast_type = "daily";
            }
          ];
        }
        {
          type = "grid";
          cards = [
            {
              type = "heading";
              heading = "Geo";
              heading_style = "title";
            }
            {
              type = "entities";
              entities = [
                { entity = "sensor.sun_next_dawn"; }
                { entity = "sensor.sun_next_dusk"; }
              ];
            }
            {
              type = "map";
              entities = [
                { entity = "person.corey"; }
                { entity = "person.daphne"; }
              ];
              theme_mode = "auto";
            }
          ];
        }
        {
          type = "grid";
          cards = [
            {
              type = "heading";
              heading_style = "title";
              heading = "Climate Control";
            }
            {
              type = "entities";
              entities = [
                "sensor.living_room_current_humidity"
                "sensor.living_room_current_temperature"
              ];
            }
          ];
        }
      ];
    }
  ];
}

