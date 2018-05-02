{ config, pkgs, ... }:

{
  require =
  [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../java-dev.nix
    ../../jenkins-node.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../postgis-server.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../vm-host.nix
  ];

  vmhost =
  {
    type = "libvirtd";
  };

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
    kernelPackages = pkgs.linuxPackages_4_14;
  };

  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_14;
    };
    permittedInsecurePackages = ["linux-4.13.16" "mono-4.0.4.1" ];
    wine.build = "wineWow";
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr";
    useDHCP = false;
    #bridges.br0.interfaces = [ "enp9s0" ];
    #interfaces.br0 =
    interfaces.enp9s0 =
    {
      ipv4.addresses = [ { address = "192.168.1.7"; prefixLength = 24; } ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
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
    "vm.nr_hugepages" = 16384;
  };

  networking.firewall =
  {
    allowedTCPPorts = [ 5000 10000 ];
  };

  hardware =
  {
    bluetooth.enable = true;
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    pulseaudio =
    {
      enable = true;
      configFile = ./pulse-audio-config.pa;
      support32Bit = true;
      daemon.config =
      {
        default-sample-rate = 96000;
        default-sample-format = "s24le";
        avoid-resampling = true;
        lock-memory = true;
      };
    };
  };

  services.kbfs =
  {
    enable = true;
  };

  services.ipfs.enable = true;

  users.users.coconnor.packages =
  [
    pkgs.firefox-devedition-bin
    pkgs.godot
    pkgs.okular
    pkgs.qgis
    pkgs.steam
    pkgs.wine
    pkgs.winetricks
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
      ];
    };
  };

  services.nix-serve =
  {
    enable = true;
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

  nix =
  {
    extraOptions = ''
      secret-key-files = /etc/nix/grr-1.sec
      keep-outputs = true
    '';
  };
}
