{ config, pkgs, ... }:
let
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
      system =
        "armv6l-linux,armv7l-linux,aarch64-linux,riscv32-linux,riscv64-linux,wasm32-wasi,wasm64-wasi";
      maxJobs = 2;
      speedFactor = 1;
    }
  ];
  localIp = "192.168.1.2";
in {
  system.stateVersion = "18.09";

  require = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../editorIsVim.nix
    ../../dev.nix
    ../../i18n.nix
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

  libvirt-host.enable = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_5_3;
    # kernelParams = ["nomodeset"];
    kernelParams = [ "amdgpu.cik_support=1" "amdgpu.si_support=1" ];
  };

  nixpkgs.config = {
    packageOverrides = in_pkgs: {
      linuxPackages = in_pkgs.linuxPackages_5_3;
      # steam = in_pkgs.steam.override { newStdcpp = true; };
    };
  };

  environment.systemPackages = [ pkgs.btrfs-progs ];

  fileSystems = {
    non-admin-home = {
      mountPoint = "/mnt/non-admin-home/";
      device = "/dev/disk/by-label/home";
    };

    storage = {
      mountPoint = "/mnt/storage";
      device = "/dev/disk/by-label/storage";
    };
  };

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    daemon = {
      config = {
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
    defaultGateway = "192.168.1.1";
    firewall = {
      allowedTCPPorts = [ 53 445 4999 27036 27037 ];
      allowedUDPPorts = [ 53 27031 27036 ];
    };
    localCommands = ''
      ${pkgs.iproute}/bin/ip route add local 192.168.100.0/24 dev lo
    '';
  };

  services.dnsmasq = {
    enable = true;
    servers =
      [ "1.1.1.1" "2606:4700:4700::1111" "8.8.8.8" "2001:4860:4860::8888" ];
    extraConfig = ''
      no-resolv
      domain-needed
      bogus-priv
      cache-size=1000
      conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
      dnssec
      bind-interfaces
      interface=enp1s0
      listen-address=::1,127.0.0.1,192.168.1.2
    '';
  };

  services.openssh = {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.xserver = {
    enable = false;
    autorun = false;
    xrandrHeads = [
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
  };

  services.journald.console = "/dev/tty12";

  system.activationScripts.non-admin-home = ''
    [ -L /home/coconnor ] || ln -s /mnt/non-admin-home/coconnor /home/coconnor
    mkdir -p /workspace/coconnor
    chown coconnor:users /workspace/coconnor
    # [ -L /workspace/coconnor] || ln -s /workspace/coconnor /home/coconnor/Development
  '';

  services.samba = {
    enable = true;
    securityType = "auto";
    extraConfig = ''
      create mask = 0664
      directory mask = 0775
      server role = standalone
      guest account = media
      map to guest = bad user
    '';
    shares = {
      media = {
        path = "/mnt/storage/media";
        comment = "Public media";
        "writeable" = true;
        "guest ok" = true;
        "guest only" = true;
      };
    };
  };

  services.kbfs = { enable = true; };

  services.nix-serve = {
    enable = true;
    port = 4999;
    secretKeyFile = "/etc/nix/agh-nix-serve-1.sec";
    extraParams = "-E development";
  };

  nix = {
    distributedBuilds = true;
    buildMachines = grrBuildMachines;
    extraOptions = ''
      secret-key-files = /etc/nix/agh-1.pem
      keep-outputs = true
    '';
  };
}
