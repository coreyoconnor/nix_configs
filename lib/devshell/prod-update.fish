#!@fishShell@
set hive_dir "$(git rev-parse --show-toplevel)"
cd "$hive_dir"

nix flake update @inputName@
