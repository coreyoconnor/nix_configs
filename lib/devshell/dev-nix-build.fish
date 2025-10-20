#!@fishShell@

if not set -q argv[1]
  echo "fragment argument required" >&2
  exit 1
end

set fragment "@fragmentSplice@"
set args $argv[2..-1]

exec nix build @nixDevInputArgs@ \
  ".?submodules=1$fragment" \
  $args
