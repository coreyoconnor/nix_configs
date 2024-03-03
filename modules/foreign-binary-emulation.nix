{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.foreign-binary-emulation;
in {
  options = {
    services.foreign-binary-emulation = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    boot.binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
      "riscv32-linux"
      "riscv64-linux"
      "wasm32-wasi"
      "wasm64-wasi"
    ];
  };
}
