#!/usr/bin/env bash

config_dir="$WORKSPACE/nix_configs"
cache_dir="$HOME/.cache/nix/jenkins-cache"

# nixpkgs-path overlays-path nixpkgs-pkgs-path
function nixpkgs-build-cache-result-path() {
    local nixpkgs_dir=$1
    local overlays_dir=$2
    local name=$3

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

    export NIX_PATH="nixpkgs-overlays=$overlays_dir"

    store_path=$(${nix_bin}nix-build --show-trace "$nixpkgs_dir"/pkgs/top-level/impure.nix \
                           --arg config "{}" \
                           -o "${results_path}" \
                           -A "pkgs.${name}")

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
