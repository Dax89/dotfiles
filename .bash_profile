#
# ~/.bash_profile
#

alias ls="ls --color=auto"
alias tree="tree -C"
alias grep="grep --color=auto"
alias dotfiles="/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias catimg="kitten icat"

# Set Environment Variables
export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3
export TERMINAL=kitty

# Configure XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Configure Flatpak
# XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share/applications:$XDG_DATA_DIRS"
# XDG_DATA_DIRS="/var/lib/flatpak/exports/share/applications:$XDG_DATA_DIRS"

# Configure Misc
export UNISON="$XDG_DATA_HOME/unison"

# Update PATH variable
PATH="$PATH:$HOME/.local/bin" # local binaries
PATH="$PATH:$HOME/.local/share/gem/ruby/3.0.0/bin" # Ruby local binaries

# Bash Appearance
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${LOGNAME}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx &> /dev/null
fi
