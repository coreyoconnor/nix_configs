{config, pkgs, ...}:
{
  require =
  [
    ./config-at-bootstrap.nix
    ../../editorIsVim.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../java-dev.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../media-presenter.nix
    ../../networks/home.nix
    ../../vm-host.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_4_12;
  nixpkgs.config.packageOverrides = in_pkgs :
  {
    linuxPackages = in_pkgs.linuxPackages_4_12;
  };

  environment.systemPackages = [
    pkgs.btrfs-progs
  ];

  fileSystems =
  [
    { mountPoint = "/mnt/non-admin-home/";
      device = "/dev/disk/by-label/home";
    }
    { mountPoint = "/mnt/storage";
      device = "/dev/disk/by-label/storage";
    }
  ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  networking =
  {
    hostName = "agh"; # must be unique
    useDHCP = false;
    interfaces.enp1s0 =
    {
      ipAddress = "192.168.1.2";
      prefixLength = 24;
      # subnetMask = "255.255.255.0";
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    firewall =
    {
      allowedTCPPorts = [ 445 ];
    };
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.openssh =
  {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.xserver =
  {
    enable = true;
    autorun = false;
  };

  services.journald.console = "/dev/tty12";

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';

  vmhost.type = "libvirtd";

  services.samba =
  {
    enable = true;
    securityType = "auto";
    extraConfig = ''
      create mask = 0664
      directory mask = 0775
      server role = standalone
      guest account = media
      map to guest = bad user
    '';
    shares =
    {
      media =
      {
        path = "/mnt/storage/media";
        comment = "Public media";
        "writeable" = true;
        "guest ok" = true;
        "guest only" = true;
      };
    };
  };
}
