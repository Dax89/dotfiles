#
# ~/.bashrc
#

[ -n "$PS1" ] && . "$HOME"/.bash_profile

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# Setup fzf integration
if command -v fzf > /dev/null; then
    eval "$(fzf --bash)"
fi
