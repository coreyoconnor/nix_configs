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
    wants = [ "vfio-force-binds.service" "systemd-udev-settle.service" ];
    restartIfChanged = false;
    serviceConfig =
    {
      Type = "simple";
    };
    # -drive file=/dev/zvol/rpool/root/waffle-1,format=raw,cache=writeback,aio=native,cache.direct=on \

    script = ''
    ${pkgs.numactl}/bin/numactl --cpunodebind=1 \
      ${pkgs.utillinux}/bin/chrt --rr 60 \
      ${pkgs.qemu_kvm}/bin/qemu-kvm -m 32G -mem-path /dev/hugepages -M q35 \
        -machine kernel_irqchip=on,usb=on \
        -cpu host,kvm=off,hv_time,hv_relaxed,hv_vapic,hv_crash,hv_reset,hv_vpindex,hv_runtime,hv_synic,hv_stimer,hv_spinlocks=0x1fff,hv_vendor_id=none \
        -realtime mlock=off \
        -smp 16,sockets=1,cores=8,threads=2 \
        -rtc base=localtime,clock=host \
        -boot menu=off,strict=on \
        -drive file=/dev/zvol/rpool/root/waffle-1,format=raw,if=virtio \
        -drive file=/mnt/storage/transfer.qcow2,if=virtio \
        -device ioh3420,multifunction=on,bus=pcie.0,id=root.1 \
        -device vfio-pci,multifunction=on,x-vga=on,host=05:00.0,bus=root.1,addr=00.0 \
        -device vfio-pci,host=05:00.1,bus=root.1,addr=00.1 \
        -device vfio-pci,host=08:00.0 -net none \
        -device vfio-pci,host=04:04.0 \
        -device usb-host,vendorid=0x045e,productid=0x028e \
        -device usb-host,vendorid=0x047d,productid=0x2041 \
        -device usb-host,vendorid=0x045e,productid=0x000b \
        -device usb-host,vendorid=0x046d,productid=0x0994 \
        -device usb-host,vendorid=0x054c,productid=0x05c4 \
        -device usb-host,vendorid=0x054c,productid=0x09cc \
        -device usb-host,vendorid=0x1a40,productid=0x0101 \
        -device usb-host,vendorid=0x04b9,productid=0x0300 \
        -device usb-host,vendorid=0x058f,productid=0x9410 \
        -device usb-host,vendorid=0x05f3,productid=0x0007 \
        -device usb-host,vendorid=0x05f3,productid=0x0081 \
        -device usb-host,vendorid=0x5332,productid=0x1300 \
        -device usb-host,vendorid=0x5332,productid=0x1400 \
        -device usb-host,vendorid=0x2b24,productid=0x0001 \
        -device usb-host,vendorid=0x056e,productid=0x010c \
        -device usb-host,vendorid=0x0d8c,productid=0x0012 \
        -device usb-host,vendorid=0x1532,productid=0x0064 \
        -vga none -nographic
    '';
  };
}
