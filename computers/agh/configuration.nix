{config, pkgs, ...}:
let
  grrBuildMachine =
  {
    hostName = "grr";
    sshUser = "nix";
    sshKey = "/root/.ssh/id_rsa";
    system = "x86_64-linux";
    maxJobs = 8;
    speedFactor = 2;
  };
  localIp = "192.168.1.2";
in
{
  system.stateVersion = "18.09";

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
    ../../openshift-host.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  boot =
  {
    kernelPackages = pkgs.linuxPackages_4_19;
    # kernelParams = ["nomodeset"];
    kernelParams = ["amdgpu.cik_support=1" "amdgpu.si_support=1"];
  };

  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_19;
      # steam = in_pkgs.steam.override { newStdcpp = true; };
    };
    kodi =
    {
      enableSteamLauncher = true;
      enableAdvancedLauncher = true;
      enableAdvancedEmulatorLauncher = true;
      enableControllers = true;
    };
  };

  environment.systemPackages = [
    pkgs.btrfs-progs
    pkgs.retroarch
    pkgs.kodi-retroarch-advanced-launchers
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
  hardware.pulseaudio =
  {
    enable = true;
    support32Bit = true;
    daemon =
    {
      config =
      {
        default-sample-rate = "48000";
        high-priority = "yes";
        realtime-scheduling = "yes";
        realtime-priority = "9";
        log-level = "debug";
        avoid-resampling = "yes";
        flat-volumes = "yes";
      };
    };
  };

  networking =
  {
    hostName = "agh"; # must be unique
    useDHCP = false;
    interfaces.enp1s0 = {
      ipv4 = {
        addresses = [ { address = localIp; prefixLength = 24; } ];
      };
      ipv6 = {
        addresses = [ { address = "2601:602:9700:f0fc::2"; prefixLength = 64; } ];
      };
    };
    defaultGateway = "192.168.1.1";
    firewall =
    {
      allowedTCPPorts = [ 445 4999 27036 27037];
      allowedUDPPorts = [ 27031 27036 ];
    };
    localCommands = ''
      ${pkgs.iproute}/bin/ip route add local 192.168.100.0/24 dev lo
    '';
  };

  services.dnsmasq.enable = true;

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
    autorun = true;
    xrandrHeads =
    [
      {
        output = "HDMI-0";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
      {
        output = "HDMI-1";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
      {
        output = "HDMI-A-0";
        monitorConfig = ''
          Option "PreferredMode" "1920x1080"
        '';
      }
    ];
    videoDrivers = [ "amdgpu" "modesetting" ];
    libinput.enable = true;
    #inputClassSections = [ ''
    #  Identifier "joystick catchall"
    #  MatchIsJoystick "on"
    #  MatchDevicePath "/dev/input/event*"
    #  Driver "joystick"
    #  Option "StartKeysEnabled" "False"       #Disable mouse
    #  Option "StartMouseEnabled" "False"      #support
    #'' ];
  };

  services.journald.console = "/dev/tty12";

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';

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

  services.kbfs =
  {
    enable = true;
  };

  services.nix-serve =
  {
    enable = true;
    port = 4999;
    secretKeyFile = "/etc/nix/agh-nix-serve-1.sec";
    extraParams = "-E development";
  };

  openshift-host.enable = true;

  nix =
  {
    distributedBuilds = true;
    buildMachines = [ grrBuildMachine ];
    extraOptions = ''
      secret-key-files = /etc/nix/agh-1.pem
      keep-outputs = true
    '';
  };
}
