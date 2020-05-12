#!/bin/sh
# Run with sh
cd $(dirname "$0")

# Create symbolic links to bin/everything
mkdir "$HOME/bin"
find bin/ -type f | while read i; do
    ln -s "$(readlink -f $i)" "$HOME/$i"
done

# Create symbolic links to everything in .dirs
find . -mindepth 1 -type d -iname '.*' | while read i; do
    if [ "$i" != "./.git" ]; then
        find "$i" -type d | while read l; do
            mkdir "$HOME/$l"
        done
        find "$i" -type f | while read l; do
            ln -s "$(readlink -f $l)" "$HOME/$l"
        done
    fi
done

# Create symbolic links to all .files
find . -type f -iname '.*' | while read i; do
    if [ "$i" != "./.gitconfig" ] && [ "$i" != "./.gitignore" ]; then
        ln -s "$(readlink -f $i)" "$HOME/$i"
    fi
done

# Some installs of cli tools
cargo install broot
cargo install ripgrep
cargo install fd-find
sudo pip3 install pypyp
# fasd
sudo add-apt-repository ppa:aacebedo/fasd
sudo apt-get update
sudo apt-get install fasd
