#!/usr/bin/env bash
set -e
source /etc/profile

config_dir="$WORKSPACE/nix_configs"
cache_dir="$HOME/.cache/nix/jenkins-cache"

function nixos-build-cache-result-path() {
    name=$1
    if [ -z "${BUILD_TAG}" ] ; then
        timestamp=$(date '+%s')
        basename="${name}-${timestamp}"
    else
        basename="${name}-${BUILD_TAG}"
    fi
    results_path="${cache_dir}/${basename}"

    if [ -z $nix ] ; then
        nix_bin=""
    else
        nix_bin="$nix/bin/"
    fi

    store_path=$(${nix_bin}nix-build --show-trace '<nixpkgs/nixos>' -o "${results_path}" -A "${name}")

    for build_dep in $(nix-store -qR $(nix-store -qd $store_path)) ; do
        ${nix_bin}nix-store --add-root "${cache_dir}/build-dep${basename}" --indirect -r $build_dep
    done

    echo $store_path
}

set -ex

mkdir -p "${cache_dir}"
find "${cache_dir}" -mindepth 1 -maxdepth 1 -mtime +30 -print -delete
