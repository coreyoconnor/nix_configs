#!@fishShell@

if not set -q argv[1]
  echo "node name required" >&2
  exit 1
end

if not set -q argv[2]
  echo "pkg name required" >&2
  exit 1
end

set fragment "#nixosConfigurations.$argv[1].pkgs.$argv[2]"
set args $argv[3..-1]

exec nix build \
  ".$fragment" \
  $args


