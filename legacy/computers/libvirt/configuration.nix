{ config, pkgs, ... }: {
  require = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../editorIsVim.nix
    ../../dev.nix
    ../../i18n.nix
    ../../jenkins-node.nix
    ../../kde5.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../vm-host.nix
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  networking = {
    hostName = "alter"; # must be unique
    useDHCP = false;
    interfaces.enp0s3 = {
      ipAddress = "192.168.1.6";
      prefixLength = 24;
      # subnetMask = "255.255.255.0";
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  nix.trustedBinaryCaches = [ "http://hydra.nixos.org" ];

  services.openssh.extraConfig = ''
    UseDNS no
  '';

  services.xserver = {
    enable = true;
    enableTCP = true;
    exportConfiguration = true;
    layout = "us";
    videoDrivers = [ "virtualbox" ];
  };

  services.journald.console = "/dev/tty12";

  vmhost.type = "libvirtd";
}
