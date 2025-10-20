#!@fishShell@

if not set -q argv[1]
  set fragment ""
  set args $argv
else
  set fragment "#$argv[1]"
  set args $argv[2..-1]
end

exec @deploy-rs@/bin/deploy --skip-checks \
  --auto-rollback false --keep-result \
  $args \
  ".?submodules=1$fragment" \
  @subcommand@ \
  -- @nixDevInputArgs@

