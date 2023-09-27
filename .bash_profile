#
# ~/.bash_profile
#

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias dotfiles="/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias catimg="kitten icat"

# Set Environment Variables
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3
export TERMINAL=kitty

PATH="$PATH:$HOME/.local/bin" # local binaries
PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin" # Ruby local binaries

# Bash Appearance
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${LOGNAME}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx &> /dev/null
fi
