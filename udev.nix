{config, pkgs, ...}:

{
  services.udev.extraRules = ''
    # Butterfly Labs Miner
    ATTRS{idVendor}=="04e8", ATTRS{idProduct}=="6860", \
      SUBSYSTEMS=="usb", ACTION=="add", MODE="0660", GROUP="plugdev"
    ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="4e42", \
      SUBSYSTEMS=="usb", ACTION=="add", MODE="0664", GROUP="plugdev"

    KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
  '';
}
