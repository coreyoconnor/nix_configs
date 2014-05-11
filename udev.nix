{config, pkgs, ...}:

{
  services.udev.extraRules = ''
ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", SUBSYSTEMS=="usb", ACTION=="add", MODE="0660", GROUP="plugdev"
  '';
}
