# INSTALL

1. Pick a config:

* toast-config.nix

This is the config of my primary linux desktop. Characteristics:
    * NVidia graphics card
    * AMD CPU
    * single monitor

    sudo ln -sf $PWD/toast-config.nix /etc/nixos/configuration.nix

* vbox-vm.nix 

This is the config of a VirtualBox VM I use for development when I have a non-Nix host.

    sudo ln -sf $PWD/vbox-vm.nix /etc/nixos/configuration.nix


2. add the nix unstable channel

    nix-channel --add http://nixos.org/channels/nixos-unstable nixos

3. Go!

    nixos-rebuild --upgrade switch

4. reboot (optional)
