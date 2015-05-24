{config, pkgs, ...}:

{
  services.udev.extraRules = ''
# Butterfly Labs Miner
ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", \
  SUBSYSTEMS=="usb", ACTION=="add", MODE="0660", GROUP="plugdev"
ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4e42", \
  SUBSYSTEMS=="usb", ACTION=="add", MODE="0664", GROUP="plugdev"
  '';
}
