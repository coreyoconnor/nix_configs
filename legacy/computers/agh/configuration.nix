{ config, pkgs, ... }:
let
  localIp = "192.168.86.2";
in {
  system.stateVersion = "18.09";

  require = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../editorIsVim.nix
    ../../dev.nix
    ../../i18n.nix
    ../../hw-rand.nix
    ../../jenkins-master.nix
    ../../libvirt-host.nix
    ../../media-downloader.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_5_4;
  };

  nixpkgs.config = {
    packageOverrides = in_pkgs: {
      linuxPackages = in_pkgs.linuxPackages_5_4;
      # steam = in_pkgs.steam.override { newStdcpp = true; };
    };
  };

  networking = {
    hostName = "agh"; # must be unique
    useDHCP = false;
    interfaces.enp1s0 = {
      ipv4 = {
        addresses = [{
          address = localIp;
          prefixLength = 24;
        }];
      };
      ipv6 = {
        addresses = [{
          address = "2601:602:9700:f0fc::2";
          prefixLength = 64;
        }];
      };
    };
    defaultGateway = "192.168.86.1";
    firewall = {
      allowedTCPPorts = [ 53 445 4999 18080 27036 27037 ];
      allowedUDPPorts = [ 53 27031 27036 ];
    };
    localCommands = ''
      ${pkgs.iproute}/bin/ip route add local 192.168.100.0/24 dev lo
    '';
  };


  services.openssh = {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.journald.console = "/dev/tty12";

  services.kbfs = { enable = true; };

}
