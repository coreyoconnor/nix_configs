{ config, pkgs, pkgs_i686, ... }:

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
      extraPackages = [ pkgs.mesa_drivers ];
      extraPackages32 = [ pkgs_i686.mesa_drivers ];
      useGLVND = true;
    };

    pulseaudio =
    {
      enable = true;
      configFile = ./pulse-audio-config.pa;
      support32Bit = true;
      daemon.config =
      {
        default-sample-rate = 96000;
        default-sample-format = "s24le";
        avoid-resampling = true;
        lock-memory = true;
      };
      package = pkgs.pulseaudioFull;
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

  sound.enable = true;
}
