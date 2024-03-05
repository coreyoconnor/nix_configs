{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./postpi
  ];

  config = {
    networking.hostName = "postpi-0";
    system.stateVersion = "23.11";
  };
}
