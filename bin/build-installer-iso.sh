#!/bin/sh

set -ex

export NIX_PATH=

drv=$(colmena eval -E "{ nodes, ... }: nodes.installer.config.system.build.isoImage" --instantiate --show-trace)
nix-store --realize --add-root "installer-iso-image" --indirect $drv

