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
    system.stateVersion = "25.05";
  };
}
