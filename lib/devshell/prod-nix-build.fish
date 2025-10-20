#!@fishShell@

if set -q argv[1]
  set fragment "@fragmentSplice@"
  set outlink $argv[1]
  set args $argv[2..-1]
else
  set fragment ""
  set outlink all
  set args $argv
end

mkdir -p .gcroots

exec nix build \
  --out-link .gcroots/$outlink \
  ".$fragment" \
  $args

