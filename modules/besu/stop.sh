#!/bin/sh
set -ex

podman stop --time 120 --ignore besu || true
podman rm --force --ignore besu || true
