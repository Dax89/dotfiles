#
# ~/.bashrc
#

[ -n "$PS1" ] && . "$HOME"/.bash_profile
[[ $- != *i* ]] && return

# Setup fzf integration
if command -v fzf > /dev/null; then
    eval "$(fzf --bash)"
fi
