# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
 CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
 DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

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
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
zstyle ':completion:*' insert-unambiguous true
zstyle :compinstall filename '/home/tolmer_v/.zshrc'

setopt appendhistory extended_glob HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS sh_word_split
unsetopt beep notify
autoload -Uz compinit
compinit
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install

bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
bindkey "^[[3~" delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

alias z=metalock
alias v=vim
autoload -U colors && colors



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
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}


    ZSH_THEME_GIT_PROMPT_PREFIX="(on %{$fg[white]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
    ZSH_THEME_GIT_PROMPT_CLEAN=""

###
    # Finally, the prompt.

    PROMPT='\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%$PR_PWDLEN<...<%~%<<$PR_BLUE)$PR_SHIFT_IN\
$PR_HBAR$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
$PR_MAGENTA$(git_prompt_info)\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
%(?..[$PR_LIGHT_RED%?$PR_BLUE])\
$PR_LIGHT_BLUE$PR_BLUE$PR_SHIFT_IN$PR_HBAR>$PR_SHIFT_OUT\
$PR_NO_COLOUR '
}

setprompt

#PROMPT="%(!.%F{red}%B.%F{white})%n %F{cyan}%~%f%#%f%b "
#RPROMPT='%F{blue}%T%f%f'
#PROMPT="$fg[red]zsh: $fg[cyan]%~> "
#RPROMPT=
#setopt nopromptcr


export EDITOR=/usr/local/bin/vim
export NNTPSERVER="news.epita.fr"
export LANG=en_US.UTF-8
export LC_ALL=fr_FR.UTF-8
export XTERM_LOCALE=fr_FR.UTF-8
export PAGER=most
export LC_CTYPE=en_US.UTF-8
export TERM=rxvt
export CC=gcc
export CXX=g++
export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
export LC_COLLATE=fr_FR.UTF-8

xmodmap ~/.Xmodmap


SCRIPTS='/.$HOME/scripts'
alias slrn="xterm -e slrn > /dev/null 2>&1 &"
alias firefox="firefox > /dev/null 2>&1 &"
alias reload="source ~/.zshrc"
alias gitignore="cat $HOME/scripts/templates/.gitignore > .gitignore"
alias headers="$SCRIPTS/headers.sh"
alias make_main="$SCRIPTS/main.sh"
alias make_test="headers src/*/* && make_main src/*/*.c"
alias moulinette="$SCRIPTS/moulinette.sh"
alias implement="$SCRIPTS/implement.sh"
alias cvalgrind="$SCRIPTS/valgrind-color.sh"
alias mkd=". $SCRIPTS/mkd.sh"
alias create_makefile="$SCRIPTS/createmakefile.sh"
alias create_makefile_rec="$SCRIPTS/createmakefilerecursive.sh"
alias train="while true; do; clear; sl; sleep 34; sl -l; sleep 26; done;"
alias gut="git"
alias create_testsuite="cp $HOME/scripts/templates/testsuite.py ."
alias create_test="$SCRIPTS/create_test.py"

alias ls="ls -G"
alias gccw="gcc -Wextra -Wall -pedantic -std=c99 -Werror"
alias gccws="gcc -Wall -Wextra -std=c99 -pedantic -Wfloat-equal -Wundef -Wshadow -Wpointer-arith -Wbad-function-cast -Wcast-qual -Wcast-align -Waggregate-return -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations -Wnested-externs -Wunreachable-code"
alias gdb="gdb -q"
alias make="gmake"

evince () { `/usr/local/bin/evince "$1" > /dev/null 2>&1 &` ;}
