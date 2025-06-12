{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    # head -c4 /dev/urandom | od -A none -t x4
    networking.hostId = "7beb36b2";
    # whatever nixpkgs is when initially setup
    system.stateVersion = "25.05";
  };
}

