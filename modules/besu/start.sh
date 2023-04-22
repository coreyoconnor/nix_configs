#!/bin/sh
set -ex
PID_FILE="$1"

# https://hub.docker.com/r/hyperledger/besu/tags
# 23.1.2
REF=sha256:daaaafba77c7b4702b55a592b6c3600e8b5775c2e14d027fb8d2345632fae2b8

# besu container user is `besu` with UID 1000
# besu container group is `besu` with GID 1000
RUN_OPTS=(
  --name besu
  --rm
  --stop-timeout 120
  --cpus 10
  --memory 16g
  --mount=type=bind,source=/mnt/storage/validator/besu,destination=/mnt/besu
  --mount=type=bind,readonly=true,source=/mnt/storage/validator/jwt/jwt.txt,destination=/etc/jwt.txt
  --log-driver=journald
  --publish 8551:8551
  --publish 8545:8545
  --publish 30303:30303
  --uidmap 1000:0:1
  --gidmap 1000:0:1
  --detach
  --cgroups=no-conmon
  --conmon-pidfile "$PID_FILE"
  --sdnotify=conmon
  --no-healthcheck # spammy
  --env BESU_OPTS='-XX:ActiveProcessorCount=10 -Xmx12g -Xss512k -XX:+PrintGC'
)

OPTS=(
  --network=mainnet
  --p2p-host=174.61.133.235
  --p2p-port=30303
  --data-storage-format=BONSAI
  --sync-mode=X_SNAP
  --data-path=/mnt/besu
  --rpc-http-enabled=true
  --rpc-http-port=8545
  --engine-rpc-enabled=true
  --engine-rpc-port=8551
  --engine-host-allowlist=localhost,127.0.0.1,192.168.86.7
  --engine-jwt-enabled=true
  --engine-jwt-secret=/etc/jwt.txt
  --Xplugin-rocksdb-high-spec-enabled
)

podman run "${RUN_OPTS[@]}" \
  "docker.io/hyperledger/besu@${REF}" \
  "${OPTS[@]}"
