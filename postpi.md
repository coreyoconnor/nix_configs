# build

`./bin/build-postpi-images.sh`

# flash

1. decompress the images `unzstd`
2. `sudo rpiboot`
3. `dd if=<decompressed image> of=/dev/sd<???>`

# Serial

`minicom --color on --baudrate 115200  --device /dev/ttyUSB0`

## Connecting a USB to Serial adapter

* https://www.raspberrypi.com/documentation/computers/os.html#gpio-and-the-40-pin-header

connect to

red - leave disconnected
gnd - pin 6 - connect to black
txd - gpio 14 - pin 8 - connect to white
rxd - gpio 15 - pin 10 - connect to green

connect with:

screen /dev/tty.??? 115200
