{config, pkgs, ...}:
{
  require =
  [
    ../../users/coconnor.nix
    ../../editorIsVim.nix
    ../../filesystem.nix
    ../../java-dev.nix
    ../../jenkins-master.nix
    ../../media-downloader.nix
    ../../networks/home.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../kde5.nix
    ../../udev.nix
    ../../vm-host.nix
    ../../proprietary_nvidia_drivers.nix
  ];

  nix.maxJobs = 10;

  boot.kernelModules = [ "acpi-cpufreq" "vhost_net" ];
  boot.kernelPackages = pkgs.linuxPackages_3_12;
  boot.extraModprobeConfig = ''
    options snd slots=snd-hda-intel
  '';

  boot.initrd.kernelModules =
  [
    "ext4"
    "ata_piix"
    "mptspi"
    "ehci_hcd"
    "pata_amd"
    "ahci"
    "usb_storage"
    "usbhid"
  ];

  boot.loader.grub =
  {
    # Use grub 2 as boot loader.
    enable = true;
    version = 2;

    device = "/dev/sda";

    extraEntries = ''
    menuentry "Win" {
        insmod ntfs
        set root='(hd1,1)'
        chainloader +1
    }
    '';
  };

  networking =
  {
    hostName = "toast"; # must be unique
    extraHosts = ''
      127.0.0.1 toast
    '';
    firewall.allowedTCPPorts = [ 8080 9091 ];
  };

  # X11 config
  # starts
  services.xserver =
  {
    enable = true;
    autorun = true;
    exportConfiguration = true;
    # windowManager.xmonad.enable = true;
    # windowManager.xmonad.enableContribAndExtras = true;
    # windowManager.default = "xmonad";
    # desktopManager.default = "none";
    layout = "us";
    # https://bbs.archlinux.org/viewtopic.php?id=117102
    deviceSection = ''
    Option "UseEvents" "false"
    '';
  };

  system.activationScripts =
  {
    removeGlobalAsoundConf = ''
      rm -f /etc/asound.conf
    '';
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];
}
