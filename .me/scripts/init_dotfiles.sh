#!/bin/sh

dotfiles() {
    git --git-dir="$HOME"/.dotfiles --work-tree="$HOME" "$@"
}

error() {
    echo "ERROR: $1"
    exit 1
}

cd "$HOME" || error "cannot change to home directory"
git clone --bare git@github.com:Dax89/dotfiles.git "$HOME"/.dotfiles

if dotfiles checkout; then
    echo "Checked out dotfiles"
else
    error "dotfiles checkout failed"
fi

dotfiles config status.showUntrackedFiles no
