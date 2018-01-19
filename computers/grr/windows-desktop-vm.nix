{ config, pkgs, ... }:

{
  vmhost =
  {
    vfio =
    {
      enable = true;
      iommu = "intel";
      nvidiaBinds = [ "10de:17c8" "10de:0fb0" ];
      forceBinds = [ "0000:08:00.0" ];
      bootBinds = [ "13f6:8788" ];
    };
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
}
