HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
zstyle :compinstall filename '/home/z3ni/.zshrc'
autoload -Uz compinit
compinit
PROMPT=" % : "
RPROMPT="%~ "

#PROMPT=" %{$fg_bold[yellow]%} $  "
#RPROMPT="%{$fg[black]%}%M:%{$fg_bold[yellow]%}%~%{$reset_color%}   "

source ~/.aliasrc
