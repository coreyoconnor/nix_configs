{ config, lib, pkgs, ... }:
with lib; {
  imports = [];

  config = {
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
      daemon = {
        config = {
          default-sample-rate = "48000";
          high-priority = "yes";
          realtime-scheduling = "yes";
          realtime-priority = "9";
          log-level = "debug";
          avoid-resampling = "yes";
          flat-volumes = "yes";
        };
      };
    };
  };
}
