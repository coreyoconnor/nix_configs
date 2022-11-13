#!/bin/sh
set -ex
PID_FILE="$1"

# https://hub.docker.com/r/consensys/teku
# 22.9.1
#REF=sha256:b6a10d8a521c8b2edcb8782b715a1d9c443d4af57ce04bb32eb4625e84c63caf
# 22.10.2
REF=sha256:6247df31ec4357a0673625d0004861b01e0797590a0422710bd8470a7314fd58
TARGET_WALLET=$(< /mnt/storage/validator/target-wallet.txt)

# teku container user is `teku` with UID 1000
# teku container group is `teku` with GID 1000
RUN_OPTS=(
  --name teku
  --rm
  --stop-timeout 120
  --cpus 4
  --memory 10g
  --mount=type=bind,source=/mnt/storage/validator/teku,destination=/mnt/teku
  --mount=type=bind,source=/mnt/storage/validator/keys,destination=/etc/keys
  --mount=type=bind,readonly=true,source=/mnt/storage/validator/jwt/jwt.txt,destination=/etc/jwt.txt
  --log-driver=journald
  --publish 9000:9000
  # prometheus endpoing is 18008
  --publish 18008:8008
  --publish 5051:5051
  --uidmap 1000:0:1
  --gidmap 1000:0:1
  --detach
  --cgroups=no-conmon
  --conmon-pidfile "$PID_FILE"
  --sdnotify=conmon
  --no-healthcheck # spammy
)

OPTS=(
  --validator-keys=/etc/keys/keystore-m_12381_3600_0_0_0-1606196657.json:/etc/keys/keystore-m_12381_3600_0_0_0-1606196657.txt
  --data-base-path=/mnt/teku
  --metrics-enabled
  --metrics-port=8008
  --rest-api-enabled
  --rest-api-docs-enabled
  --rest-api-port=5051
  --p2p-enabled=true
  --p2p-port=9000
  --p2p-peer-upper-bound=80
  --p2p-advertised-ip=174.61.133.235
  --log-destination=CONSOLE
  --ee-endpoint http://192.168.86.7:8551
  --ee-jwt-secret-file /etc/jwt.txt
  --validators-proposer-default-fee-recipient $TARGET_WALLET
  --validators-builder-registration-default-enabled=true --builder-endpoint=http://192.168.86.7:18550
)

podman run "${RUN_OPTS[@]}" \
  "docker.io/consensys/teku@${REF}" \
  "${OPTS[@]}"
