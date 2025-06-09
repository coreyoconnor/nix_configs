{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
  ];

  config = {
    services.pipewire.wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/98-alsa-lowlatency.conf"
        (builtins.readFile ./alsa-low-latency.conf)
      )
      (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-spidf-no-sleep.conf"
        (builtins.readFile ./spidf-no-sleep.conf)
      )
    ];
  };
}

