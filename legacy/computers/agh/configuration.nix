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
      listen-address=::1,127.0.0.1,192.168.86.2
    '';
  };

  services.fail2ban.enable = true;

  services.openssh = {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.journald.console = "/dev/tty12";


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
      backup = {
        path = "/mnt/storage/backup";
        comment = "Backup";
        "writeable" = false;
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
