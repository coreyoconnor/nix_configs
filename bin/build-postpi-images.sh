#!/bin/sh

set -ex

export NIX_PATH=

for I in $(seq 1 7); do
    drv=$(colmena eval -E "{ nodes, ... }: nodes.postpi-${I}.config.system.build.sdImage" --instantiate --show-trace)
    nix-store --realize --add-root "postpi-${I}-image" --indirect $drv
done
