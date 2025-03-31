{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [./default.nix];

  config = {
    networking = {
      interfaces = {
        eno1.useDHCP = true;
        enp2s0.useDHCP = true;
        wlp4s0.useDHCP = true;
      };

      wireless.enable = true;
    };
  };
}
