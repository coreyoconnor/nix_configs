CURRENT_CONFIG=`echo $NIX_PATH | sed -s 's#.*\(computers/\w*/configuration.nix\).*#\1#'`
echo "building config ${CURRENT_CONFIG} in ${PROJECT_DIR}"
NIX_PATH="nixos=${PROJECT_DIR}/nixpkgs/nixos"
NIX_PATH="${NIX_PATH}:nixpkgs=${PROJECT_DIR}/nixpkgs"
NIX_PATH="${NIX_PATH}:nixos-config=${PROJECT_DIR}/${CURRENT_CONFIG}"
export NIX_PATH="${NIX_PATH}:services=/etc/nixos/services"
echo "using NIX_PATH=${NIX_PATH}"
