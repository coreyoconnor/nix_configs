{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.desktop.hyprland;
in {
  options.desktop.hyprland.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      swayidle
      swaylock
      xdg-user-dirs
      xdg-utils
    ];

    programs.hyprland = {
      enable = true;
      xwayland.hidpi = true;
    };

    security.pam.services.swaylock = {};

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
    };
  };
}
