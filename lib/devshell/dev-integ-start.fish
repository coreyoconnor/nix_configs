#!@fishShell@
cd "$(git rev-parse --show-toplevel)"

cd dev

baseSha=$(cat "@inputName@-base-sha.txt")
echo "rebase from upstream base revision: $baseSha"

cd "@inputName@"

git rev-parse --abbrev-ref HEAD | read actualBranch

if test "$actualBranch" != "@targetBranch@"
  echo "current branch is not @targetBranch@"
  exit 1
end

git remote get-url upstream | read actualUpstreamRemote

if test "$actualUpstreamRemote" != "@sourceRemote@"
  echo "upstream is not @sourceRemote@"
  exit 1
end

if not git diff-files --quiet
  echo "unstaged changes in @inputName@ - cannot integ upstream into @targetBranch@"
  exit 1
end

if not git diff-index --quiet --cached @targetBranch@
  echo "staged changes in @inputName@ - cannot integ upstream into @targetBranch@"
  exit 1
end

git fetch upstream
git show '--format=%H' upstream/@sourceBranch@ > ../@inputName@-base-next-sha.txt
git rebase --interactive --onto upstream/@sourceBranch@ $baseSha @targetBranch@

