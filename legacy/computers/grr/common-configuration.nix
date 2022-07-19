{ config, pkgs, ... }:
let
  localIp = "192.168.86.7";
  localIpAlt = "192.168.86.17";
in {
  system.stateVersion = "18.09";

  require = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../desktop.nix
    ../../dev.nix
    ../../jenkins-node.nix
    ../../tobert-config.nix
  ];

  users.users.coconnor.packages = [
    pkgs.google-drive-ocamlfuse
    pkgs.hugo
    pkgs.keybase
    pkgs.nix-dev
  ];

  fileSystems = {
    "/mnt/storage/media" = {
      fsType = "cifs";
      device = "//agh/media";
      options = [
        "guest"
        "uid=media"
        "gid=users"
        "rw"
        "setuids"
        "file_mode=0664"
        "dir_mode=0775"
        "vers=3.0"
        "nofail"
      ];
    };
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

    # KeepKey HID Firmware/Bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2b24", ATTR{idProduct}=="0001", MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="keepkey%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2b24", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"

    # KeepKey WebUSB Firmware/Bootloader
    SUBSYSTEM=="usb", ATTR{idVendor}=="2b24", ATTR{idProduct}=="0002", MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="keepkey%n"
    KERNEL=="hidraw*", ATTRS{idVendor}=="2b24", ATTRS{idProduct}=="0002",  MODE="0666", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
  '';

}
