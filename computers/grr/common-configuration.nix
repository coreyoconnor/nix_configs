{ config, pkgs, ... }:
let
  localIp = "192.168.1.7";
in {
  system.stateVersion = "18.09";

  require =
  [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../java-dev.nix
    ../../jenkins-node.nix
    ../../i18n.nix
    ../../musnix
    ../../networks/home.nix
    ../../postgis-server.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../libvirt-host.nix
  ];

  libvirt-host.enable = true;

  # grub bootloader installed to all devices in the boot raid1 array
  boot =
  {
    loader.grub =
    {
      devices =
      [
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055024"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055124"
      ];
      enable = true;
      fontSize = 24;
      font = "${pkgs.corefonts}/share/fonts/truetype/cour.ttf";
      zfsSupport = true;
      version = 2;
    };

    kernelParams = [ "kvm-intel.nested=1" ];
    kernelPackages = pkgs.linuxPackages_4_18;
  };

  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_18;
    };
    permittedInsecurePackages = ["linux-4.13.16" "mono-4.0.4.1" ];
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr";
    useDHCP = false;
    interfaces.enp9s0 =
    {
      ipv4.addresses = [ { address = localIp; prefixLength = 24; } ];
      ipv6 = {
        addresses = [ { address = "2601:602:9700:f0fc::7"; prefixLength = 64; } ];
      };
    };
    nameservers = [ "192.168.1.2" "1.1.1.1" ];
    defaultGateway = "192.168.1.1";
    firewall =
    {
        allowedTCPPorts = [ 4999 10000 ];
    };
  };

  services.openssh = {
    extraConfig = ''
        UseDNS no
    '';
    forwardX11 = true;
  };

  services.journald.console = "/dev/tty12";

  boot.kernel.sysctl =
  {
    "vm.nr_hugepages" = 16484;
  };

  sound.enable = true;

  hardware =
  {
    bluetooth.enable = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };

  musnix =
  {
    enable = false;
    kernel =
    {
      latencytop = true;
      optimize = true;
      realtime = true;
      # must match computer linuxPackages version
      packages = pkgs.linuxPackages_4_14_rt;
    };
  };

  services.kbfs =
  {
    enable = true;
  };

  users.users.coconnor.packages =
  [
    pkgs.godot
    pkgs.mono
    pkgs.okular
    pkgs.qgis
    pkgs.steam
    pkgs.virtmanager
    pkgs.virt-viewer
  ];

  fileSystems =
  {
    "/mnt/storage/media" =
    {
      fsType = "cifs";
      device = "//agh/media";
      options =
      [
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
  '';

  services.nix-serve =
  {
    enable = true;
    port = 4999;
  };

  nix =
  {
    extraOptions = ''
      secret-key-files = /etc/nix/grr-1.sec
      keep-outputs = true
    '';
  };
  virtualisation.docker.storageDriver = "zfs";
}
