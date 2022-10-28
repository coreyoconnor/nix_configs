#!/bin/sh
set -ex

podman stop --time 120 --ignore mev-boost || true
podman rm --force --ignore mev-boost || true
