#!/bin/sh

check_command() {
    printf "Checking \e[0;36m%s\e[0m -> " "$1"

    if ! command -v "$1" > /dev/null; then
        printf "\e[0;31mNOT FOUND\e[0m\n"
        exit 2
    fi

    printf "\e[0;32mOK\e[0m\n"
}

error() {
    echo "$1"
    exit 2
}

BINPATH="$1"
[ -z "$BINPATH" ] && error "Invalid BINPATH"

check_command "cmake"
check_command "g++"

cd "$HOME/.me/apps" || error "Cannot find 'apps' directory"
builddir="$PWD"/build

printf ">> Building in \e[0;34m%s\e[0m...\n" "$builddir"
cmake -S . -B "$builddir" -DCMAKE_BUILD_TYPE=Release

cd "$builddir" || error "Cannot find '$builddir' directory"
cmake --build . --config Release -j2

targets=$(cmake --build . --target help | awk '/^\.\.\./{print $2}')
cd ..

echo "$targets" | while read -r tgt; do
   filepath="$builddir/$tgt"

   if [ -f "$filepath" ]; then
       printf ">> Copying \e[0;31m%s\e[0m in \e[0;34m%s\e[0m\n" "$tgt" "$BINPATH"
       pkill -9 -x "$tgt"
       mv -f "$filepath" "$BINPATH"
   fi
done

echo ">> Cleaning build directory..."
rm -r "$builddir"

cd "$HOME" || error "'$HOME' directory not found"

echo "$targets" | while read -r tgt; do
   filepath="$BINPATH/$tgt"

   if [ -f "$filepath" ]; then
       printf ">> Starting \e[0;31m%s\e[0m...\n" "$tgt"
       "$filepath" &
       pgrep -a -x "$tgt"
   fi
done

