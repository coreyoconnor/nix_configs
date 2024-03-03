{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  postgresql = pkgs.postgresql_13;
in {
  services.postgresql = {
    enable = true;
    package = postgresql;
    extraPlugins = [(pkgs.postgis.override {inherit postgresql;})];
    extraConfig = ''
      max_wal_size = 4096
      max_connections = 400
      listen_addresses = '*'
      work_mem = 4096
      log_min_duration_statement = 100
    '';
    authentication = ''
      host all all 192.168.1.1/24 trust
    '';
  };

  environment.systemPackages = [
    (pkgs.osm2pgsql.override {inherit postgresql;})
    postgresql
  ];

  networking.firewall.allowedTCPPorts = [5432];
}
