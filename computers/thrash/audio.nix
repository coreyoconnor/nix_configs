{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.pulseaudio = {
    enable = false;
    systemWide = true;
  };

  sound = {
    enable = true;
    extraConfig = ''
      pcm.!default {
        type hw
        card 0
        device 3
      }
      ctl.!default {
        type hw
        card 0
        device 3
      }
    '';
  };
}
