# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  require = 
  [
    ../user-coconnor.nix
    ../java-dev.nix
    ../editorIsVim.nix
    ../standard-env.nix
    ../standard-packages.nix
    ../standard-services.nix
    ../haskell-dev.nix
    ../i18n.nix
    ../kde4.nix
    ./hardware-configuration.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub =
  {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  hardware.nvidiaOptimus.disable = true;
  boot.kernelPackages = pkgs.linuxPackages_3_12;

  networking =
  {
    hostName = "flop"; # Define your hostname.
    # networkmanager.enable = true;
    wireless =
    {
      enable = true;  # Enables wireless.
      userControlled.enable = true;
      interfaces = [ "wlp4s0" ];
    };
    extraHosts = ''
      192.168.1.142 toast
    '';
  };

  system.activationScripts =
  {
    configureAlsa = ''
      cp ${./asound.conf} /etc/asound.conf
    '';
  };

  environment.shellInit = ''
      NIX_PATH=nixos=/home/coconnor/Development/nix_configs/nixpkgs/nixos
      NIX_PATH=$NIX_PATH:nixos-config=/home/coconnor/Development/nix_configs/flop/configuration.nix
      NIX_PATH=$NIX_PATH:services=/etc/nixos/services
      NIX_PATH=$NIX_PATH:nixpkgs=/home/coconnor/Development/nix_configs/nixpkgs
      export NIX_PATH
  '';

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.upower.enable = true;

  # Enable the X11 windowing system.
  services.xserver =
  {
    enable = true;
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
  services.xserver.desktopManager.kde4.enable = true;

  environment.systemPackages = 
  [
    pkgs.xorg.xf86inputsynaptics
  ];
}
