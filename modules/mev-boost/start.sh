#!/bin/sh
set -ex
PID_FILE="$1"

# https://hub.docker.com/r/flashbots/mev-boost/tags
# flashbots/mev-boost:v1.3.2-portable
# REF=sha256:8c57eaaf6111bac8fe8c381b57e5ef7ce52d422af41cd4e09f36d181de5e21a9
# flashbots/mev-boost:1.4.0-rc4-portable
#REF=sha256:1491d0be77309615c7c43f1b1f9418f84ab36b587c448ab5cce4b56c2e5f5d15
# 1.4.0
REF=sha256:08cca2d62cd269b98ba507ff69472d48e172bf257942b86306a995b7745fa6cc

# container user is `root` with UID 0
# container group is `root` with GID 0
RUN_OPTS=(
  --name mev-boost
  --rm
  --stop-timeout 120
  --cpus 4
  --memory 2g
  --log-driver=journald
  --publish 18550:18550
  --detach
  --cgroups=no-conmon
  --conmon-pidfile "$PID_FILE"
  --sdnotify=conmon
)

RELAY_0=https://0xac6e77dfe25ecd6110b8e780608cce0dab71fdd5ebea22a16c0205200f2f8e2e3ad3b71d3499c54ad14d6c21b41a37ae@boost-relay.flashbots.net
RELAY_1=https://0xb3ee7afcf27f1f1259ac1787876318c6584ee353097a50ed84f51a1f21a323b3736f271a895c7ce918c038e4265918be@relay.edennetwork.io
RELAY_2=https://0xad0a8bb54565c2211cee576363f3a347089d2f07cf72679d16911d740262694cadb62d7fd7483f27afd714ca0f1b9118@bloxroute.ethical.blxrbdn.com
RELAY_3=https://0xa1559ace749633b997cb3fdacffb890aeebdb0f5a3b6aaa7eeeaf1a38af0a8fe88b9e4b1f61f236d2e64d95733327a62@relay.ultrasound.money

OPTS=(
    -addr 0.0.0.0:18550
    -mainnet
    -relay-check
    -relays $RELAY_0,$RELAY_1,$RELAY_2,$RELAY_3
    -request-timeout-getheader 8000
    -request-timeout-getpayload 8000
    -request-timeout-regval 6000
)

podman run "${RUN_OPTS[@]}" \
  "docker.io/flashbots/mev-boost@${REF}" \
  "${OPTS[@]}"
