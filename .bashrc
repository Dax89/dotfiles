#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep="grep --color=auto"
alias vi="nvim"
alias vim="nvim"
alias dotfiles="/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias killtmux="kill -9 `pidof tmux`"

# export PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin"

PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${LOGNAME}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

tput smkx # Enable 'Delete' key
