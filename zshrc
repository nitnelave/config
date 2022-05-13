eval `dircolors -b ~/.dircolors`
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# Disable software flow control, i.e. Ctrl-S freezes
stty -ixon

# If a glob has no match, leave as-is
setopt +o nomatch

# Setup fzf
# ---------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

FZF_DEFAULT_COMMAND='rg -g ""'

bindkey '^g' fzf-cd-widget
# Remove esc-c as fzf trigger
bindkey -r '\ec'

# Completion
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '$HOME/.zshrc'

[ -f ~/.zsh/_git ] && zstyle ':completion:*:*:git:*' script ~/.completion/git/git-completion.sh && fpath=(~/.zsh $fpath)

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


typeset -g _START_TIMER
typeset -g _END_TIMER

print_hours () {
  N=$1
  H=$((N / 3600))
  N=$((N - H * 3600))
  echo -n "${H}h, "
  print_minutes $N
}

print_minutes () {
  N=$1
  M=$((N / 60))
  N=$((N - M * 60))
  echo -n "${M}m, "
  print_seconds $N
}

print_seconds () {
  echo -n "${N}s"
}

print_formatted_time () {
  echo -n "Execution took "
  N=$1
  if [ $N -gt 3600 ]
  then
    print_hours $N
  else
    print_minutes $N
  fi
  echo ""
}

_start_timer () {
  _START_TIMER=$(date +%s)
  _END_TIMER=$_START_TIMER
}

_stop_timer () {
  _END_TIMER=$(date +%s)
  DIFF=$((_END_TIMER - _START_TIMER))
  # between 2 min and 1 day
  if [ $DIFF -gt 120 -a $DIFF -lt 8640000 ]
  then
    print_formatted_time $DIFF
  fi
  _START_TIMER=$_END_TIMER
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _start_timer
add-zsh-hook precmd _stop_timer

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(on %b%c%u)'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '!'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' actionformats '(%b [%a%c%u])'

# Prompt
function precmd {
  vcs_info
  local TERMWIDTH
  (( TERMWIDTH = ${COLUMNS} - 1 ))

  PR_FILLBAR=""
  PR_PWDLEN=""

  # Remove colors from the git output to count the characters
  ZSH_THEME_GIT_PROMPT_PREFIX="(on "
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"
  ZSH_THEME_GIT_PROMPT_DIRTY="!"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="?"

  # Measure the different parts of the prompt
  local pwdsize=${#${(%):-%~}}
  local gittext="${vcs_info_msg_0_}-"
  local gitsize=${"#${gittext}"}

  local PADDING=7

  # Truncate the path if it's too long.
  if [[ "$gitsize + $pwdsize + $PADDING" -gt $TERMWIDTH ]]; then
    ((PR_PWDLEN=$TERMWIDTH - $gitsize - $PADDING))
  else
    PR_FILLBAR="\${(l.(($TERMWIDTH - ($pwdsize + $gitsize + $PADDING)))..${PR_HBAR}.)}"
  fi

  # Put the colors back
  ZSH_THEME_GIT_PROMPT_PREFIX="$fg[blue]($fg[magenta]on %{$fg[white]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="$fg[blue])%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
}

setprompt () {
    # Need this so the prompt will work.

    setopt prompt_subst

    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
      colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

###size
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=─
    PR_ULCORNER=┌
    PR_LLCORNER=└
    PR_LRCORNER=┘
    PR_URCORNER=┐

    VISUAL_BELL=$(echo -e '\a')

    ZSH_THEME_GIT_PROMPT_PREFIX="(on %{$fg[white]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    if [[ -z "$DISPLAY" ]] ; then HOST_NAME='($PR_GREEN$PR_SHIFT_OUT%m$PR_SHIFT_IN$PR_CYAN)'; else unset HOST_NAME; fi
###
    # Finally, the prompt.

    PROMPT='\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%$PR_PWDLEN<...<%~%<<$PR_BLUE)$PR_SHIFT_IN\
$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
$PR_MAGENTA${vcs_info_msg_0_}\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT$VISUAL_BELL\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER'"$HOST_NAME"'$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
%(?..[$PR_LIGHT_RED%?$PR_BLUE])\
$PR_LIGHT_BLUE$PR_BLUE$PR_SHIFT_IN$PR_HBAR>$PR_SHIFT_OUT\
$PR_NO_COLOUR '
}

setprompt

fpath=(~/.zsh/completion $fpath)

autoload -Uz compinit && compinit -i

ttyctl -f

source ~/.aliases
alias reload="source ~/.zshrc"

export PATH=$PATH:~/projects/config/bin:~/.bin/nvim-linux64/bin


if which fuck >/dev/null
then
  eval $(thefuck --alias)
  run_fuck () {
    echo
    fuck --enable-experimental-instant-mode </dev/tty
    echo '\n'
    zle redisplay
  }
  zle -N run_fuck
  bindkey '^f' run_fuck
fi

[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(direnv hook zsh)"
