# Using

## Manual Bootstrap

1. clone this repo
2. `git submodule update --init --recursive`
3. create or select a config under `computers`
    * this name of the directory containing the config should match the hostname
4. `export NIX_PATH=computers/$HOSTNAME/configuration.nix`
5. `./bin/build`
6. `./bin/switch

## Auto Bootstrap

This part is in development. Not usable at this time.

Create a user equivalent to:
    * https://github.com/coreyoconnor/nix_configs/blob/master/users/admin.nix

bootstrap using nix-configs-bootstrap:

    git clone git@github.com:coreyoconnor/nix-configs-bootstrap.git
    cd nix-configs-bootstrap
    git submodule update --init --recursive
    nix-build .
    ./result/bin/nix-configs-bootstrap

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
