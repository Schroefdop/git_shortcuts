# ----------------------
# Git Aliases
# ----------------------
alias ga='git add'
alias gaa='git add .'
alias gaaa='git add --all'
alias gau='git add --update'
alias gb='git branch'
alias gbr='git branch -r' # Remote branches
alias gba='git branch -a' # All branches
# alias gbd='git branch -D' # Delete branch (gbd <branch name>)
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gca='git commit --am'
# alias gco='git checkout'
alias gcof='git checkout HEAD -- ' #gcof <filename> to reset file
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcos='git checkout staging'
alias gcod='git checkout develop'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gda='git diff HEAD'
alias gf='git fetch'
alias glo='git log --oneline'
alias glg='git log --graph --oneline --decorate --all'
alias glp='git log --pretty=format:"%Cred%h%Creset|%Cgreen%ad%Creset|%Cgreen%cr%Creset|%C(bold blue)<%an>%Creset"\n"%C(yellow)%d%Creset %s" --abbrev-commit --date=short' # Print git log data on two line
alias gm='git merge --no-ff'
alias gmd='git merge --no-ff develop'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gp='git pull'
alias gpr='git pull --rebase'
alias gr='git rebase'
alias grd='git rebase develop'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias grmc='git rm --cached' #To ignore untracked files like grc <filename>
alias gs='git status'
alias gss='git status --short'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'
alias gitconfig='git config --global --edit'
alias checkoutRemoteBranch="git checkout -t <name of remote>/test"

# Git log find by commit message
glf() {
  git log --all --grep=$argv
}

# Git push local branch to equally named origin branch
gpb() {
  currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
  git push origin $currentBranch
}

# Clear all stashes
gstc() {
  read -l -P "Clear all stashes? [Y/n] " confirm

  case "$confirm" in
  [yY])
    git stash clear
    echo "Stashes cleared 👍"
    return 0
    ;;
  *)
    echo "¯\_(ツ)_/¯"
    gstl
    ;;
  esac
}

# Clean the remote branches
gbrp() {
  echo "Branches before clean: "
  gbr
  echo "Cleaning remote..."
  git remote update origin --prune
  echo "Done 👍"
  echo "Branches after clean: "
  gbr
}

# Reset current branch to equal named origin branch
gbreset() {
  currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
  read -l -p "Reset current branch <$currentBranch> to <origin/$currentBranch>? [y/n] " confirm

  case "$confirm" in
  [yY])
    git reset --hard origin/$currentBranch
    ;;
  *)
    echo "¯\_(ツ)_/¯"
    ;;
  esac
}

gco() {
  _listBranches "checkout"
}

gbd() {
  _listBranches "deletion"
}

gcor() {
  _listBranches "remote checkout"
}

_listBranches() {
  branchesFile=$TMPDIR'branches'
  trap "{ rm -f $branchesFile; }" EXIT

  case $1 in
  "remote checkout") git branch -r >$branchesFile ;; # Get remote branches
  *) git branch >$branchesFile ;;                    # Get local branches
  esac

  n=1
  while read line; do
    if [[ $line == *"*"* ]]; then
      currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
      echo "Current branch:\n${GREEN}$currentBranch${NOCOLOR}"
      # Remove the current branch from the file, we cannot checkout current branch
      sed -i "" $n\d $branchesFile
    fi
    n=$((n + 1))
  done <$branchesFile

  echo "Branches available for $1:"
  n=1
  while read line; do
    if [[ $line != *"*"* ]]; then
      echo "$n. ${RED}$line${NOCOLOR}"
      n=$((n + 1))
    fi
  done <$branchesFile

  printf 'Branch number: '
  read tmp
  branch=$(head -$tmp $branchesFile | tail -1 | awk '{$1=$1};1')

  case $1 in
  "remote checkout")
    git checkout -t $branch
    ;;
  "checkout")
    git checkout $branch
    ;;
  "deletion")
    printf "${RED}Are you sure you want to delete branch ${NOCOLOR}$branch${RED}? [y/n]${NOCOLOR} "

    read confirm
    case "$confirm" in
    [yY]) git branch -D $branch ;;
    *) echo "¯\_(ツ)_/¯" ;;
    esac
    ;;
  esac
}

howToCommit() {
  echo "
  ##### Make proper commit messages #####

  A properly formed git commit subject line should always be able to complete the following sentence:
  'If applied, this commit will <your subject line here>'

  ### Rules for a great git commit message style ###

  - Separate subject from body with a blank line
  - Do not end the subject line with a period
  - Capitalize the subject line and each paragraph
  - Use the imperative mood in the subject line
  - Wrap lines at 72 characters
  - Use the body to explain what and why you have done something. In most cases, you can leave out details about how a change has been made.

  Refererence for more details:
  https://gist.github.com/robertpainsi/b632364184e70900af4ab688decf6f53#a-properly-formed-git-commit-subject-line-should-always-be-able-to-complete-the-following-sentence
  "
}
