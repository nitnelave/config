DIRCOL=dircolors
if ! which dircolors >/dev/null && which gdircolors > /dev/null
then
  DIRCOL=gdircolors
fi
eval `$DIRCOL -b ~/.dircolors`
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# Disable software flow control, i.e. Ctrl-S freezes
stty -ixon

# If a glob has no match, leave as-is
setopt +o nomatch

export TERM="xterm-256color"

# Completion
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '$HOME/.zshrc'

[ -e ~/.completion/git ] && zstyle ':completion:*:*:git:*' script ~/.completion/git/git-completion.sh && fpath=(~/.zsh $fpath)

[ -e ~/.zsh/zsh-autosuggestions ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# History
setopt appendhistory extended_glob HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS sh_word_split
autoload -Uz compinit
compinit -u
export HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
autoload -U edit-command-line
bindkey "^q" push-line-or-edit

unsetopt beep notify

# Setup fzf
# ---------

FZF_DEFAULT_COMMAND='rg -g ""'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '^g' fzf-cd-widget
# Remove esc-c as fzf trigger
bindkey -r '\ec'
bindkey -r '^T'

autoload up-line-or-beginning-search
autoload down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
# Key shortcuts
bindkey "^[[3~" delete-char
bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward
bindkey "^N" up-line-or-beginning-search
bindkey "^t" down-line-or-beginning-search
bindkey "^_" beginning-of-line
bindkey "^a" beginning-of-line
bindkey "^[^_" end-of-line
bindkey "^e" end-of-line
bindkey "^H" backward-word
bindkey "^S" forward-word
bindkey "^?" backward-delete-char

# Colors
autoload -U colors && colors
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;31;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;1;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[032;1;146m' # begin underline

export EDITOR=nvim
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit && compinit -i

# Freeze TTY controls.
ttyctl -f

source ~/.aliases
alias reload="source ~/.zshrc"

export PATH=$PATH:~/projects/config/bin:~/.bin/nvim/bin:~/.cargo/bin:~/.local/bin:~/.bin

[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(direnv hook zsh)"


# Setup Starship.

eval "$(starship init zsh)"
