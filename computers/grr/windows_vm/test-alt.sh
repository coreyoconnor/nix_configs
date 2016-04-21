#!/bin/sh
set -ex

         # -L /nix/store/698m813d798969n1pzkasmy9xk4x2abd-qemu-x86-only-2.5.1/share/qemu/ \
         # -device vfio-pci,x-vga=on,multifunction=on,host=05:00.0,bus=root.1,addr=00.0,romfile=./GM200.rom \

export QEMU_AUDIO_DRV=alsa
export QEMU_ALSA_DAC_PERIOD_SIZE=24
export QEMU_ALSA_DAC_BUFFER_SIZE=1024
export QEMU_AUDIO_DAC_FIXED_FREQ=48000

qemu-kvm -m 24G -M q35 \
         -cpu host,kvm=off,hv_vendor_id=none \
         -smp 16,sockets=1,cores=8,threads=2 \
         -rtc base=localtime \
         -drive file=/dev/zvol/rpool/root/waffle-1,format=raw \
         -drive file=/dev/sdb,format=raw \
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
         -vga none -nographic \
         "$@"

# -usbdevice host:003.006 \
# -usbdevice host:003.007 \

#
# -device vfio-pci,x-vga=on,multifunction=on,host=04:00.0,romfile=./EVGA.GTX470.1280.100416_6.rom \
# -device vfio-pci,host=04:00.1 \
# -device vfio-pci,host=09:00.0 \
# -device vfio-pci,host=0b:00.0 \
# -device vfio-pci,host=00:1a.0 \
# -device vfio-pci,host=00:1b.0 \
# -device vfio-pci,host=00:1d.0 \
# -device vfio-pci,host=06:04.0 \
# -vga none -nographic \
