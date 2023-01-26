#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# SSH workaround for urxvt
TERM=xterm-256color

alias ls='ls --color=auto'
alias vi="nvim"
alias vim="nvim"
alias dotfiles="/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

PS1='[\u@\h \W]\$ '
