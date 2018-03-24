{config, pkgs, lib, ...}:
with lib;
let postgresql = pkgs.postgresql100;
in {
  services.postgresql =
  {
    enable = true;
    package = postgresql;
    extraPlugins = [ (pkgs.postgis.override { inherit postgresql; }) ];
  };

  environment.systemPackages =
  [
    (pkgs.osm2pgsql.override { inherit postgresql; })
  ];
}
