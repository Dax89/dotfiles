#
# ~/.bash_profile
#

alias ls="ls --color=auto"
alias tree="tree -C"
alias grep="grep --color=auto"
alias dotfiles='/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias icat="kitten icat"
alias syncapps='$HOME/.me/apps/sync_apps.sh'
alias fetch='curl -O'

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
export JQ_COLORS="0;37:0;35:0;35:0;33:0;32:1;39:1;39:1;34"
export UNISON="$XDG_DATA_HOME/unison"
export GOPATH="$XDG_DATA_HOME/go"
export QL_LOCAL_PROJECTS="$XDG_DATA_HOME/quicklisp"
export XBPS_SRC_ROOT="$XDG_DATA_HOME/void/void-packages"
# Update PATH variable
PATH="$PATH:$HOME/.local/bin" # local binaries

# Bash Appearance
PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${LOGNAME}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
PS1="\[\033[01;92m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $ "

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx &>/dev/null
fi
