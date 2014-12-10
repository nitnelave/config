eval `dircolors ~/.dircolors`
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras ssh-agent)

source $ZSH/oh-my-zsh.sh

# Completion
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle :compinstall filename '$HOME/.zshrc'

# History
setopt appendhistory extended_glob HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS sh_word_split
autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v

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
bindkey "^T" down-line-or-beginning-search
bindkey "^_" beginning-of-line
bindkey "^[^_" end-of-line
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



# Prompt
function precmd {
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
  local gittext="$(git_prompt_info)-"
  local gitsize=${"#${gittext}"}

  local PADDING=7

  # Truncate the path if it's too long.
  if [[ "$gitsize + $pwdsize + $PADDING" -gt $TERMWIDTH ]]; then
    ((PR_PWDLEN=$TERMWIDTH - $gitsize - $PADDING))
  else
    PR_FILLBAR="\${(l.(($TERMWIDTH - ($pwdsize + $gitsize + $PADDING)))..${PR_HBAR}.)}"
  fi

  # Put the colors back
  ZSH_THEME_GIT_PROMPT_PREFIX="(on %{$fg[white]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
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
$PR_MAGENTA$(git_prompt_info)\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER'"$HOST_NAME"'$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
%(?..[$PR_LIGHT_RED%?$PR_BLUE])\
$PR_LIGHT_BLUE$PR_BLUE$PR_SHIFT_IN$PR_HBAR>$PR_SHIFT_OUT\
$PR_NO_COLOUR '
}

setprompt



ttyctl -f


# Compilers
alias clang++w="clang++ -Wextra -Wall -pedantic -std=c++11 -Werror"
alias clang++ws="clang++ -Wall -Wextra -std=c++11 -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wmissing-declarations -Wunreachable-code"
alias clangw="clang -Wextra -Wall -pedantic -std=c99 -Werror"
alias clangws="clang -Wall -Wextra -std=c99 -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Wunreachable-code"
alias g++w="g++ -Wextra -Wall -pedantic -std=c++11 -Werror"
alias g++ws="g++ -Wall -Wextra -std=c++11 -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wcast-qual -Wcast-align -Wmissing-declarations -Wunreachable-code"
alias gccw="gcc -Wextra -Wall -pedantic -std=c99 -Werror"
alias gccws="gcc -Wall -Wextra -std=c99 -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Wunreachable-code"

# Git
alias gi="git"
alias gits="git"
alias gmerge="$SCRIPTS/gmerge.sh"
alias gt="git"
alias gu="git"
alias gut="git"


# Templates
alias create_makefile="$SCRIPTS/createmakefile.sh"
alias create_makefile_rec="$SCRIPTS/createmakefilerecursive.sh"
alias create_test="$SCRIPTS/create_test.py"
alias create_testsuite="cp $HOME/scripts/templates/testsuite.py ."
alias gitignore="cp $HOME/scripts/templates/.gitignore ."
alias pom-xml="cp $HOME/scripts/templates/pom.xml ."


# Scripts
alias headers="$SCRIPTS/headers.sh"
alias implement="$SCRIPTS/implement.sh"
alias mkd=". $SCRIPTS/mkd.sh"
alias cvalgrind="$SCRIPTS/valgrind-color.sh"
alias moulinette="$SCRIPTS/moulinette.py"
alias screen="$SCRIPTS/screen.sh"
alias z="$LOCK"

# Maven
alias mvn-javadoc="mvn clean javadoc:javadoc scm-publish:publish-scm"
alias mvn-release="mvn release:clean && mvn release:prepare && mvn release:perform"
alias mvn-snapshot="mvn clean deploy"

# misc commands
alias gdb="gdb -q"
alias eclipse="eclipse > /dev/null 2>&1 &"
alias ls="ls -phG"
alias cortune=$HOME/projects/config/cowsay.sh
alias mkdir="mkdir -pv"
alias irc="ssh -t owncloud@tolmer.fr \"zsh -c 'tmux attach -t irc'\""
alias reload="source ~/.zshrc"
alias s="ls"
alias no="ls"
alias suspend="sudo pm-suspend"
alias tax="tar xf"
alias train="while true; do; clear; sl; sleep 34; sl -l; sleep 26; done;"
alias v=vim
alias vim="stty stop '' -ixoff ; vim"

# funny message
if which cowsay >/dev/null && which fortune >/dev/null; then
  cortune
fi
