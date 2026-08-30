#!@fishShell@
cd $(git rev-parse --show-toplevel)/dev/@inputName@

git rev-parse --abbrev-ref HEAD | read actualBranch

if test "$actualBranch" != "@sourceBranch@"
  echo "current branch is not @sourceBranch@"
  exit 1
end

git remote get-url origin | read actualOriginRemote

if test "$actualOriginRemote" != "@targetRemote@"
  echo "origin is not @targetRemote@"
  exit 1
end

if not git diff-files --quiet
  echo "unstaged changes in @inputName@ - cannot push to @targetBranch@"
  exit 1
end

if not git diff-index --quiet --cached @sourceBranch@
  echo "staged changes in @inputName@ - cannot push to @targetBranch@"
  exit 1
end

git fetch

git rev-list --count origin/@sourceBranch@...@sourceBranch@ | read originDiff

if test "$originDiff" != "0"
  echo "@sourceBranch@ is not up to date with @targetRemote@ @sourceBranch@"
  exit 1
end

git push --force $argv origin @sourceBranch@:@targetBranch@

cd $(git rev-parse --show-toplevel)

prod-update-@inputName@

