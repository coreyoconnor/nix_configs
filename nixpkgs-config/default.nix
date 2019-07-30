{config, pkgs, lib, ...} :
with lib;
let
  overlaysDir = builtins.readDir ./overlays;
  itemNames = attrNames overlaysDir;
  isImportable = f: builtins.match ".*\\.nix" f != null || pathExists (./overlays + ("/" + f + "/default.nix"));
  overlays = map (f: import (./overlays + ("/" + f))) (builtins.filter isImportable itemNames);
in {
  inherit overlays;
  config = import ./config.nix;
}
