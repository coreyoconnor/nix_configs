{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    nix = {
      maxJobs = 4;
    };
  };
}
