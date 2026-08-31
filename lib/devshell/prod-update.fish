#!@fishShell@
cd $(git rev-parse --show-toplevel)

nix flake update @inputName@
