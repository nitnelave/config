[ -z "$PS1" ] && return

eval `dircolors ~/.dircolors`


# History
HISTFILE=~/.histfile
HISTSIZE=10000
shopt -s histappend

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
#autoload up-line-or-beginning-search
#autoload down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
# Key shortcuts
#bind "^[[3~":delete-char
#bind "^[[A":history-search-backward
#bind "^[[B":history-search-forward
bind "C-N":history-search-backward
bind "C-T":history-search-forward
bind "C-_":beginning-of-line
bind "C-_":end-of-line
bind "C-H":backward-word
bind "C-S":forward-word

# Colors
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;31;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;1;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[032;1;146m' # begin underline

shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


setprompt () {
    # Need this so the prompt will work.


    # See if we can use colors.

#    if [[ "$terminfo[colors]" -ge 8 ]]; then
#      colors
#    fi
    count=1
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color="$(tput setaf $count)"
        eval PR_LIGHT_$color="$(tput setaf $(( $count + 8)))"
        (( count = $count + 1 ))
    done
    PR_NO_COLOUR="$(tput sgr0)"

###size
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    PR_SET_CHARSET=#"%{$terminfo[enacs]%}"
    PR_SHIFT_IN=#"%{$terminfo[smacs]%}"
    PR_SHIFT_OUT=#"%{$terminfo[rmacs]%}"
    unset PR_SET_CHARSET
    unset PR_SHIFT_IN
    unset PR_SHIFT_OUT
    PR_HBAR=─
    PR_ULCORNER=┌
    PR_LLCORNER=└
    PR_LRCORNER=┘
    PR_URCORNER=┐


    if [[ -z "$DISPLAY" ]] ; then HOST_NAME='($PR_GREEN$PR_SHIFT_OUT$HOSTNAME$PR_SHIFT_IN$PR_CYAN)'; else unset HOST_NAME; fi
###
    # Finally, the prompt.

    PR_PWD='`pwd`'

    PS1="\
$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN$PR_PWD$PR_BLUE)$PR_SHIFT_IN\
$PR_HBAR$PR_HBARPR_HBAR>$PR_SHIFT_OUT\
$PR_NO_COLOUR "
}

setprompt





# Git
alias g="git"
alias gi="git"
alias gits="git"
alias gt="git"
alias gu="git"
alias gut="git"

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
alias irc="ssh -t nitnelave@server.tolmer.fr \"zsh -c 'tmux attach -t irc'\""
alias reload="source ~/.zshrc"
alias s="ls"
alias no="ls"
alias suspend="sudo pm-suspend"
alias tax="tar xf"
alias train="while true; do; clear; sl; sleep 34; sl -l; sleep 26; done;"
alias v=vim
alias vs="vim --servername VIM"
alias va="vim --servername VIM --remote-tab"
alias vim="stty stop '' -ixoff ; vim"
alias grep="grep --color=auto"

alias ipython-slides="ipython nbconvert --to slides --post serve"

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
