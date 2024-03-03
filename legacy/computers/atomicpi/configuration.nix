# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  grrBuildMachines = [
    {
      hostName = "grr";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system = "i686-linux,x86_64-linux";
      maxJobs = 8;
      speedFactor = 2;
    }
    {
      hostName = "grr";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system = "armv6l-linux,armv7l-linux,aarch64-linux,riscv32-linux,riscv64-linux,wasm32-wasi,wasm64-wasi";
      maxJobs = 2;
      speedFactor = 1;
    }
  ];
  localIp = "192.168.86.8";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../nixpkgs-config.nix
    ../../standard-env.nix
    ../../atmo-monitor.nix
    ../../networks/home.nix
    <nixpkgs/nixos/modules/profiles/headless.nix>
    <nixpkgs/nixos/modules/profiles/minimal.nix>
  ];

  atmo-monitor.enable = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    optimise.automatic = true;

    distributedBuilds = true;
    buildMachines = grrBuildMachines;
  };

  systemd.tmpfiles.rules = ["R /tmp/nix* - - - 60d" "R! /tmp/* - - - 6m"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "atomicpi";
  networking.wireless.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp0s20u3.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  nixpkgs.config = {
    netbeans = false;
    vim = {
      gui = "none";
      lua = false;
      perl = false;
      python = false;
      ruby = false;
    };
  };

  environment.systemPackages = with pkgs; [
    curl
    arduino-cli
    git
    dfu-programmer

    # vim_configurable
    (v4l-utils.override {withGUI = false;})

    (fswebcam.overrideAttrs (oldAttrs: {
      src = fetchgit {
        url = "https://github.com/coreyoconnor/fswebcam.git";
        rev = "4f9c743112fc31a96a35769219b04c86707f5fa9";
        sha256 = "0f31fal967h02miidmvgcnlf1mqzm7mr60wag6bk1966izz43bj5";
      };

      configureFlags = ["--enable-32bit-buffer"];
    }))
  ];

  environment.noXlibs = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  fileSystems = {
    "/mnt/storage/media" = {
      fsType = "cifs";
      device = "//192.168.86.2/media";
      options = [
        "guest"
        "uid=coconnor"
        "gid=users"
        "rw"
        "setuids"
        "file_mode=0664"
        "dir_mode=0775"
        "vers=3.0"
        "x-systemd.requires=network-online.target"
        "x-systemd.after=network-online.target"
      ];
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
