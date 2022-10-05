#!/bin/sh
set -ex

podman stop --time 120 --ignore teku || true
podman rm --force --ignore teku || true
