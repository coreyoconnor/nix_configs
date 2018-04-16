{ config, pkgs, ... }:

{
  require =
  [
    ./common-configuration.nix
    ../../desktop.nix
  ];

  hardware =
  {
    opengl =
    {
      enable = true;
      driSupport32Bit = true;
      useGLVND = true;
    };
  };

  services.xserver =
  {
    desktopManager =
    {
      default = "plasma5";
      plasma5.enable = true;
    };
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      BusID "PCI:05:00:00"
    '';
    xrandrHeads =
    [
      {
        output = "DVI-I-1-1";
        monitorConfig = ''
          Option "PreferredMode" "2560x1080"
        '';
        primary = true;
      }
    ];
    inputClassSections =
    [ ''
      Identifier "joystick catchall"
      MatchIsJoystick "on"
      MatchDevicePath "/dev/input/event*"
      Driver "joystick"
      Option "StartKeysEnabled" "False"
      Option "StartMouseEnabled" "False"
    '' ];
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
    '';
  };
}
