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
alias gc='git commit'
alias gcm='git commit --message'
alias gcf='git commit --fixup'
alias gca='git commit --am'
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
alias glp='git log --pretty=format:"%Cred%h%Creset|%Cgreen%ad%Creset|%Cgreen%cr%Creset|%C(bold blue)<%an>%Creset""%C(yellow)%d%Creset %s" --abbrev-commit --date=short' # Print git log data on two line
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
alias git.fix='git diff --name-only | uniq | xargs code'

# Git log find by commit message
glf() {
  git log --all --grep=$argv
}

# Git push local branch to equally named origin branch
gpb() {
  currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
  git push -u origin $currentBranch
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

# Clean remote/local branches
grp() {
  git remote update origin --prune

  NUMBER_OF_BRANCHES_REMOVED=$(git branch -vv | grep -c ': gone]')

  if [[ $NUMBER_OF_BRANCHES_REMOVED > 0 ]]; then

    printf "${RED}Prune local branches?${NOCOLOR} [y/n] "

    read confirm
    case "$confirm" in
    [yY])
      git branch -vv | grep ': gone]' | grep -v '\*' | awk '{ print $1; }' | xargs git branch -D
      ;;
    *)
      echo "¯\_(ツ)_/¯"
      ;;
    esac
  else
    echo "${RED}No local branches to prune${NOCOLOR}"
  fi
}

# Reset current branch to equal named origin branch
gbreset() {
  currentBranch=$(git branch | grep \* | cut -d ' ' -f2)
  printf "Reset current branch <$currentBranch> to <origin/$currentBranch>? [y/n] "
  read confirm
  
  case "$confirm" in
  [yY])
    git reset --hard origin/$currentBranch
    ;;
  *)
    echo "¯\_(ツ)_/¯"
    ;;
  esac
}
