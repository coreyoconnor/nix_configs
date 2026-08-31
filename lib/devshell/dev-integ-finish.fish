#!@fishShell@
cd "$(git rev-parse --show-toplevel)"

cd "dev/@inputName@"

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
git push -f origin @sourceBranch@:@targetBranch@

cd ..

cp @inputName@-base-next-sha.txt @inputName@-base-sha.txt
git add @inputName@*
git commit @inputName@* -m 'update @inputName@'

