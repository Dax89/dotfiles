#! /bin/sh

if [[ $PWD == $HOME ]]; then
    echo "Cannot execute scrippt from home"
fi

ln -s ~/.config/st/config.h .
makepkg -C
unlink config.h
yay -U ./st-*.tar.zst
rm -rf pkg/ src/ *.tar* .[A-zA-Z_]*
