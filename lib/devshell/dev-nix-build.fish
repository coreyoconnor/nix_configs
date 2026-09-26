#!@fishShell@
set hive_dir "$(git rev-parse --show-toplevel)"
cd "$hive_dir"

if set -q argv[1]
  set fragment "@fragmentSplice@"
  set args $argv[2..-1]
else
  set fragment ""
  set args $argv
end

exec nix build @nixDevInputArgs@ \
  ".?submodules=1$fragment" \
  $args
