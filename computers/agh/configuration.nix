{config, pkgs, ...}:
{
  require =
  [
    ./config-at-bootstrap.nix
    ../../cgminer.nix
    ../../editorIsVim.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../java-dev.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../networks/home.nix
    ../../vm-host.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
    ../../users/coconnor.nix
    ../../users/admin.nix
  ];

  fileSystems =
  [ 
    { mountPoint = "/mnt/non-admin-home/";
      device = "/dev/disk/by-label/home";
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
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.openssh.extraConfig = ''
    UseDNS no
  '';

  services.xserver = 
  {
    enable = true;
    autorun = false;
  };

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';
}
