# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  require = 
  [
    ../user-coconnor.nix
    ../editorIsVim.nix
    ../standard-env.nix
    ../standard-packages.nix
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
      #minSpeed = "0.5";
      #maxSpeed = "1.2";
      #accelFactor = "0.1";
      # additionalOptions = ''
      #   Option "HorizHysteresis" "1"
      #   Option "VertHysteresis" "1"
      #   Option "SHMConfig" "true"
      #   Option "FingerHigh" "15"
      #   Option "FingerLow" "2"
      #   Option "SendCoreEvents" "true"
      #   Option "AccelerationProfile" "-1"
      #   Option "AccelerationScheme" "none"
      # '';
    };
  };
  services.xserver.desktopManager.kde4.enable = true;

  environment.systemPackages = 
  [
    pkgs.xorg.xf86inputsynaptics
  ];
}
