{ config, pkgs, ... }:

{
  require = 
  [
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../filesystem.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../java-dev.nix
    ../../jenkins-node.nix
    ../../kde5.nix
    ../../logging.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../vm-host.nix
    ../../users/admin.nix
    ../../users/coconnor.nix
    ./primus.nix
  ];

  hardware.enableAcerPrimus = true;

  nixpkgs.config.packageOverrides = in_pkgs :
  {
    linuxPackages = in_pkgs.linuxPackages_3_18;
  };

  boot =
  {
    # Use the GRUB 2 boot loader.
    loader.grub =
    {
      enable = true;
      version = 2;
      device = "/dev/sda";
    };
    
    kernelPackages = pkgs.linuxPackages_3_18;

    extraModprobeConfig = ''
      options snd-hda-intel index=1
    '';

    postBootCommands = ''
      echo 0 > /sys/bus/usb/devices/1-6/authorized
    '';
  };

  powerManagement =
  {
    powerUpCommands = ''
      echo 0 > /sys/bus/usb/devices/1-6/authorized
    '';

    resumeCommands = ''
      echo 0 > /sys/bus/usb/devices/1-6/authorized
    '';
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  networking =
  {
    hostName = "flop"; # Define your hostname.
    wireless =
    {
      enable = true;  # Enables wireless.
      userControlled.enable = true;
      interfaces = [ "wlp4s0" ];
    };
    dhcpcd.extraConfig = ''
      ipv4only
    '';
    enableIPv6 = false;
  };

  system.activationScripts =
  {
    removeGlobalAsoundConf = ''
      rm -f /etc/asound.conf
    '';
  };

  # Enable the X11 windowing system.
  services.xserver =
  {
    enable = true;
    videoDrivers = [ "intel" ];
    exportConfiguration = true;
    layout = "us";

    synaptics =
    {
      enable = true;
      twoFingerScroll = true;
      tapButtons = false;
      buttonsMap = [1 3 2];
      palmDetect = true;
      minSpeed = "1.5";
      maxSpeed = "100";
      accelFactor = "0.34";
      additionalOptions = ''
        Option "SHMConfig" "true"
        Option "FingerLow" "5"
        Option "FingerHigh" "20"
        Option "ConstantDeceleration" "20"
        Option "AdaptiveDeceleration" "20"
        Option "VertResolution" "62"
        Option "HorizResolution" "64"
        Option "HorizHysteresis" "1"
        Option "VertHysteresis" "1"
      '';
    };

  };

  environment.systemPackages = 
  [
    pkgs.xorg.xf86inputsynaptics
  ];
}
