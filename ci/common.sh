#!/usr/bin/env bash
set -e
source /etc/profile

config_dir="$WORKSPACE/nix_configs"
cache_dir="$HOME/.cache/nix/jenkins-cache"

function nixos-build-cache-result-path() {
    set +e
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

    set -x
    store_path=$(${nix_bin}nix-build --show-trace '<nixpkgs/nixos>' -o "${results_path}" -A "${name}")
    set +x

    (
    if [ ! -z "${BUILD_TAG}" ] ; then
        for build_dep in $(nix-store -qR $(nix-store -qd $store_path)) ; do
            root="${cache_dir}/build-dep-$(basename $build_dep)"
            if [ ! -e "$root" ] ; then
                ${nix_bin}nix-store --add-root "$root" --indirect -r $build_dep
            fi
        done
    fi
    ) > /dev/null

    echo $store_path
}

set -e

mkdir -p "${cache_dir}"
find "${cache_dir}" -mindepth 1 -maxdepth 1 -mtime +30 -print -delete || true
