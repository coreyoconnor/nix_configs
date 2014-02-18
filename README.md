# Configs I use

* computers/toast/configuration.nix

This is the config of my primary linux desktop. Specs:
    * NVidia graphics card. Uses nvidia driver and not nouveau.
    * AMD CPU
    * single monitor

* computer/vbox/configuration.nix

This is the config of a VirtualBox VM I use for development when I have a non-Nix host.

* computers/nixpad/configuration.nix

MacBook Pro SantaRosa system. 4,1?

* computers/flop/configuration.nix

Acer Aspire V7 582PG

  * Core i5
  * synaptics touchpad
  * bumblebee switch is used to select *only* the Intel integrated card.
  * not in UEFI boot mode

# Prep

* add the nix unstable channel

    nix-channel --add http://nixos.org/channels/nixos-unstable nixos
