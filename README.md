### Installation
Open terminal and paste the following lines. This will clone the repository to the right location, add `bootSimulator` to the plugins located in `~/.zshrc` and restart your shell.

```
git clone https://github.com/Schroefdop/git_shortcuts.git ~/.oh-my-zsh/custom/plugins/custom_git
while read line; do; if [[ $line == plugins* ]]; then; sed -i -e 's/plugins=(/plugins=(custom_git /g' ~/.zshrc; fi;  done < ~/.zshrc
exec zsh
```
