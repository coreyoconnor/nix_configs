{ config, pkgs, ... }:
let
  localIp = "192.168.86.7";
  localIpAlt = "192.168.86.17";
in {
  system.stateVersion = "18.09";

  require = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../desktop.nix
    ../../dev.nix
    ../../editorIsVim.nix
    ../../jenkins-node.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../libvirt-host.nix
  ];

  libvirt-host.enable = true;

  networking = {
    hostId = "34343134";
    hostName = "grr";
    useDHCP = false;
    useNetworkd = true;
    networkmanager.enable = false;
    interfaces = {
      enp10s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = localIpAlt;
          prefixLength = 24;
        }];
        ipv6 = {
          addresses = [{
            address = "2601:602:9700:f0fc::17";
            prefixLength = 64;
          }];
        };
      };
      enp11s0 = {
        useDHCP = false;
        ipv4.addresses = [{
          address = localIp;
          prefixLength = 24;
        }];
        ipv6 = {
          addresses = [{
            address = "2601:602:9700:f0fc::7";
            prefixLength = 64;
          }];
        };
      };
    };
    nameservers = [ "192.168.86.2" "1.1.1.1" ];
    defaultGateway = "192.168.86.1";
    firewall = { enable = false; allowedTCPPorts = [ 4000 4999 8000 10000 ]; };
  };

  services.openssh = {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };

  services.journald.console = "/dev/tty12";

  boot.kernel.sysctl = { "vm.nr_hugepages" = 16484; };

  sound.enable = true;

  services.kbfs = { enable = true; };

  users.users.coconnor.packages = [
    pkgs.google-drive-ocamlfuse
    pkgs.hugo
    pkgs.keybase
    pkgs.nix-dev
  ];

  fileSystems = {
    "/mnt/storage/media" = {
      fsType = "cifs";
      device = "//agh/media";
      options = [
        "guest"
        "uid=media"
        "gid=users"
        "rw"
        "setuids"
        "file_mode=0664"
        "dir_mode=0775"
        "vers=3.0"
        "nofail"
      ];
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="2b7c", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="3b7c", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="4b7c", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1807", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1808", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0000", MODE="0660", GROUP="plugdev"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0001", MODE="0660", GROUP="plugdev"

    SUBSYSTEM=="usb", ATTR{idVendor}=="2b24", ATTR{idProduct}=="0001", MODE="0666", GROUP="plugdev", SYMLINK+="keepkey%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2b24", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="plugdev"

    # KeepKey HID Firmware/Bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2b24", ATTR{idProduct}=="0001", MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="keepkey%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2b24", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

    # KeepKey WebUSB Firmware/Bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2b24", ATTR{idProduct}=="0002", MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="keepkey%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2b24", ATTRS{idProduct}=="0002",  MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
  '';

  services.nix-serve = {
    enable = true;
    port = 4999;
    secretKeyFile = "/etc/nix/grr-1.sec";
  };

  nix = {
    extraOptions = ''
      keep-outputs = true
      secret-key-files = /etc/nix/grr-1.sec
    '';
  };
}
