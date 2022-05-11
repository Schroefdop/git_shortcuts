### Installation
Open terminal and paste the following lines. This will clone the repository to the right location, add `git_shortcuts` to the plugins located in `~/.zshrc` and restart your shell.

```
git clone https://github.com/Schroefdop/git_shortcuts.git ~/.oh-my-zsh/custom/plugins/git_shortcuts
while read line; do; if [[ $line == plugins* ]]; then; sed -i -e 's/plugins=(/plugins=(git_shortcuts /g' ~/.zshrc; fi;  done < ~/.zshrc
exec zsh
```
