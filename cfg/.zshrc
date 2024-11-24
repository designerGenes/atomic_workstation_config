# Created by newuser for 5.9
export ZPLUG_HOME="$HOME/.zplug"
source $ZPLUG_HOME/init.zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "esc/conda-zsh-completion"
zplug "golang/go", use:"misc/zsh/go"
zplug "romkatv/powerlevel10k", as:theme
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

if ! zplug check --verbose; then
	zplug install
fi

fpath=(/users/jadennation/.zsh/completions $fpath)

zplug load
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

autoload -U compinit && compinit

# Ensure Powerlevel10k theme configuration is
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Custom Aliases
alias gs='git status'
export ZSHRC="/users/jadennation/.zshrc"
alias rezsh='source "$ZSHRC" && echo reloaded ZSH' 
alias vimZ='vim "$ZSHRC"'
alias vimVim="vim ~/.vimrc"
export TERM=xterm-256color

source $HOME/dev/bin/aliases.sh
source $HOME/dev/bin/deepdeletefunc.sh
source $HOME/dev/bin/customPath.sh

HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt INC_APPEND_HISTORY 

cp $HOME/.zshrc $HOME/dev/bin/.zshrc_copy

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
fc -R

# Bind UP and DOWN arrows for history substring search
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
