export ZSH="$HOME/.oh-my-zsh"
export ZPLUG_HOME="$HOME/.zplug"
source $ZPLUG_HOME/init.zsh && echo "Initialized Zplug"
source $ZSH/oh-my-zsh.sh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "esc/conda-zsh-completion"
zplug "romkatv/powerlevel10k", as:theme
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check --verbose; then
	zplug install
fi

zplug load

# Ensure Powerlevel10k theme configuration is
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Custom Aliases
alias gs='git status'
alias deepDelete=deepdelete

# Environment variables and PATH adjustments
export PATH="$PATH:$HOME/dev/bin"
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/dev/python:$HOME/dev/python/ca:$PATH"
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export PATH="$PATH:$HOME/.docker/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PATH="/Users/jadennation/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/sbin:/opt/homebrew/opt:$PATH"

# Other environment variables
export KEYS_PATH="$HOME/dev/ASSETS/keys.yml"
export PYTHONPATH="/users/jadennation/dev/python:$PYTHONPATH"
export CONFIG="$HOME/.config"
export HASS_SERVER='http://fencepostcat.local:8123'
export HASS_TOKEN='your_token_here'
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTO_UPDATE=1
export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw /Library/Developer/Toolchains/swift-latest.xctoolchain/Info.plist)

# Rancher Desktop-managed environment variables
export PATH="/Users/jadennation/.rd/bin:$PATH"

export ZSHRC="/users/jadennation/.zshrc"
alias rezsh='source "$ZSHRC" && echo reloaded ZSH' 
alias vimZ='vim "$ZSHRC"'
alias vimVim="vim ~/.vimrc"
export TERM=xterm-256color
