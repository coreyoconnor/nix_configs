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
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../vm-host.nix
    # ./windows-desktop-vm.nix
    ../../desktop.nix
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
      enable = true;
      version = 2;
      devices =
      [
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001801"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420002543"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420003186"
        "/dev/disk/by-id/ata-ADATA_SP550_2G0420001635"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055024"
        "/dev/disk/by-id/ata-ADATA_SP550_2G3220055124"
      ];
      zfsSupport = true;
    };

    # kernelParams = [ "kvm-intel.nested=1" ];
    kernelPackages = pkgs.linuxPackages_4_14;
  };

  nixpkgs.config =
  {
    packageOverrides = in_pkgs :
    {
      linuxPackages = in_pkgs.linuxPackages_4_14;
      wine = in_pkgs.winePackages.full.override { wineRelease = "stable"; };
    };
    permittedInsecurePackages = ["linux-4.13.16"];
    wine.build = "wineWow";
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr";
    useDHCP = false;
    bridges.br0.interfaces = [ "enp9s0" ];
    interfaces.br0 =
    {
      ipv4.addresses = [ { address = "192.168.1.7"; prefixLength = 24; } ];
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.openssh.extraConfig = ''
    UseDNS no
  '';

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
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    opengl =
    {
      enable = true;
      driSupport32Bit = true;
      useGLVND = true;
    };

    pulseaudio =
    {
      enable = true;
      configFile = ./pulse-audio-config.pa;
      support32Bit = true;
    };
  };

  services.xserver =
  {
    desktopManager =
    {
      default = "plasma5";
      plasma5.enable = true;
    };
    videoDrivers = [ "nvidia" ];
    deviceSection = ''
      BusID "PCI:05:00:00"
    '';
    xrandrHeads =
    [
      {
        output = "DVI-I-1-1";
        monitorConfig = ''
          Option "PreferredMode" "2560x1080"
        '';
        primary = true;
      }
    ];
    inputClassSections =
    [ ''
      Identifier "joystick catchall"
      MatchIsJoystick "on"
      MatchDevicePath "/dev/input/event*"
      Driver "joystick"
      Option "StartKeysEnabled" "False"
      Option "StartMouseEnabled" "False"
    '' ];
    screenSection = ''
      Option "metamodes" "nvidia-auto-select +0+0 { ForceCompositionPipeline = On }"
    '';
  };

  services.kbfs =
  {
    enable = true;
  };

  services.ipfs.enable = true;

  users.users.coconnor.packages =
  [
    pkgs.okular
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
}
