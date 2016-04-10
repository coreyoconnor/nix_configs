# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  require =
  [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../editorIsVim.nix
    ../../i18n.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../users/coconnor.nix
    ../../users/admin.nix
    ../../vm-host.nix
  ];

  boot.kernelParams = [ "loglevel=7" "nomodeset" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # grub bootloader installed to all devices in the boot raid1 array
  boot.loader.grub =
  {
    enable = true;
    version = 2;
    devices = [ "/dev/sdf" "/dev/sdg" "/dev/sdh" "/dev/sdi" ];
  };

  networking =
  {
    hostName = "grr"; # must be unique
    useDHCP = false;
    interfaces.enp10s0 =
    {
      ipAddress = "192.168.1.7";
      prefixLength = 24;
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  nix.trustedBinaryCaches = ["http://hydra.nixos.org"];

  services.openssh.extraConfig = ''
    UseDNS no
  '';

  services.journald.console = "/dev/tty12";

  vmhost.type = "libvirtd";

  system.stateVersion = "16.03";
}
