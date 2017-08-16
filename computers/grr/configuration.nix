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
    ../../java-dev.nix
    ../../jenkins-node.nix
    ../../i18n.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../status-tty.nix
    ../../tobert-config.nix
    ../../vm-host.nix
  ];

  nixpkgs.config.packageOverrides = in_pkgs :
  {
    linuxPackages = in_pkgs.linuxPackages_4_12;
  };

  vmhost =
  {
    type = "libvirtd";
    vfio =
    {
      enable = true;
      iommu = "intel";
      nvidiaBinds = [ "10de:17c8" "10de:0fb0" ];
      forceBinds = [ "0000:08:00.0" ];
      bootBinds = [ "13f6:8788" ];
    };
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

    kernelParams = [ "kvm-intel.nested=1" ];
    kernelPackages = pkgs.linuxPackages_4_12;
  };

  networking =
  {
    hostId = "34343134";
    hostName = "grr"; # must be unique
    useDHCP = false;
    interfaces.enp9s0 =
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

  system.stateVersion = "16.03";

  boot.kernel.sysctl =
  {
    "vm.nr_hugepages" = 16384;
  };

  systemd.defaultUnit = "graphical.target";

  systemd.services."display-manager" =
  {
    description = "starts windows desktop.";
    after = [ "vfio-force-binds.service" "systemd-udev-settle.service" "local-fs.target" "acpid.service" "systemd-logind.service" ];
    wants = [ "systemd-udev-settle.service" ];
    restartIfChanged = false;
    serviceConfig =
    {
      Type = "simple";
    };
    # -drive file=/dev/zvol/rpool/root/waffle-1,format=raw,cache=writeback,aio=native,cache.direct=on \

    script = ''
    ${pkgs.numactl}/bin/numactl -N 0 \
      ${pkgs.qemu_kvm}/bin/qemu-kvm -m 24G -mem-path /dev/hugepages -M q35 \
        -machine kernel_irqchip=on \
        -cpu max,kvm=off,hv_time,hv_relaxed,hv_vapic,hv_spinlocks=0x1fff,hv_vendor_id=none \
        -smp 16,sockets=1,cores=8,threads=2 \
        -rtc base=localtime \
        -drive file=/dev/zvol/rpool/root/waffle-1,format=raw \
        -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
        -device vfio-pci,multifunction=on,x-vga=on,host=05:00.0,bus=root.1,addr=00.0 \
        -device vfio-pci,host=05:00.1,bus=root.1,addr=00.1 \
        -device vfio-pci,host=08:00.0 -net none \
        -device vfio-pci,host=04:04.0 \
        -usbdevice host:045e:028e \
        -usbdevice host:047d:2041 \
        -usbdevice host:045e:000b \
        -usbdevice host:046d:0994 \
        -usbdevice host:054c:05c4 \
        -usbdevice host:054c:09cc \
        -usbdevice host:1a40:0101 \
        -usbdevice host:04b9:0300 \
        -usbdevice host:058f:9410 \
        -usbdevice host:05f3:0007 \
        -usbdevice host:05f3:0081 \
        -usbdevice host:5332:1300 \
        -usbdevice host:2b24:0001 \
        -vga none -nographic
    '';
  };

  services.xserver.displayManager.xpra.enable = true;
  networking.firewall =
  {
    allowedTCPPorts = [ 10000 ];
  };

  systemd.services.update-freemyip =
  {
    description = "Updates FreeMyIP";

    path = [ pkgs.curl ];

    serviceConfig =
    {
      Type = "oneshot";
      User = "nobody";
    };
    script = ''
      set -ex
      curl https://freemyip.com/update?token=588f227086d6557b1589553c&domain=grr.freemyip.com
    '';
  };

  systemd.timers.update-freemyip =
  {
    wantedBy = [ "timers.target" ];
    timerConfig =
    {
      OnCalendar = "*:0/30";
      Persistent = "yes";
    };
  };
}
