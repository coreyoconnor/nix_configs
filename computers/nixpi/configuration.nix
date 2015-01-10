{pkgs, config, ...}:

{
  boot.loader.grub.enable = false;
  boot.loader.generationsDir.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_3_6_rpi;
  boot.kernelParams = [
    "coherent_pool=6M"
    "smsc95xx.turbo_mode=N"
    "dwc_otg.lpm_enable=0"
    "root=/dev/mmcblk0p2"
    "rootwait"
    "console=tty1"
    "elevator=deadline"
  ];

  fonts = {
    fontconfig.enable = false;
    enableGhostscriptFonts = false;
    enableFontDir = false;
    enableCoreFonts = false;
  };
  fileSystems = [
    {
      device = "/dev/sda5";
      mountPoint = "/";
      fsType = "ext4";
    }
    {
      device = "/dev/mmcblk0p1";
      mountPoint = "/boot";
      fsType = "vfat";
    }
  ];
  swapDevices =
  [ 
    { device = "/dev/disk/by-label/swap"; }
  ];
  powerManagement.enable = false;

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "ca_ES.UTF-8/UTF-8" "en_GB.UTF-8" ];
  };

  services.xserver.enable = false;
  services.nixosManual.enable = false;
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.sysstat
    pkgs.ts
    pkgs.tm
    pkgs.git
    pkgs.atop
  ];

  nixpkgs.config = {
    platform = pkgs.platforms.raspberrypi;
    stdenv.userHook = "if [ -f /niximpure/impure.sh ]; then . /niximpure/impure.sh; fi";
    gnutls.guile = false;
    packageOverrides = p:{
      nix = p.lib.overrideDerivation p.nix (attrs: {
        patchPhase = "sed -i s/-9// corepkgs/nar.nix";
        });
      git = p.git.override { withManual = false; };
    };
  };
}
