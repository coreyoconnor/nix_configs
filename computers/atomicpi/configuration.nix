# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../nixpkgs-config.nix
      ../../standard-env.nix
      ../../standard-services.nix
      ../../atmo-monitor.nix
      ../../networks/home.nix
      <nixpkgs/nixos/modules/profiles/headless.nix>
      <nixpkgs/nixos/modules/profiles/minimal.nix>
    ];

  atmo-monitor.enable = true;

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

  users.users.coconnor = {
    isNormalUser = true;
    extraGroups = [ "dialout" "wheel" "video" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAxlFWIpiLwwLlQ7Bgj37ARdoWvFAb6Na+D3b5kvWK9O coconnor@glowness"
    ];
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
    # vim_configurable
    (v4l-utils.override { withGUI = false; })

    (fswebcam.overrideAttrs(oldAttrs: {
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
      device = "//192.168.1.2/media";
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
