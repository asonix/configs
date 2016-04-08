#!/usr/bin/env bash

# I need to evaluate symlinks because idk where a userwould call this from
SOURCE="${BASH_SOURCE}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, it needs to be resolved
done
DIR="$( cd "$( dirname "$SOURCE}" )" && pwd )"

# setup neovim
mkdir -p "$HOME/.config/nvim/autoload"
cp "$DIR/init.vim" "$HOME/.config/nvim/"

if [ ! -f "$HOME/.config/nvim/autoload/plug.vim" ]; then
  curl -fLo "$HOME/.config/nvim/autoload/plug.vim" \
    "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
fi

cp -r "$DIR/i3" "$HOME/.config"
cp -r "$DIR/i3status" "$HOME/.config"
cp "$DIR/.zshrc" "$HOME"
cp "$DIR/.zshenv" "$HOME"
cp "$DIR/.profile" "$HOME"
cp "$DIR/subtle.rb" "$HOME/.config"
cp "$DIR/compton.conf" "$HOME/.config"
cp "$DIR/.Xresources" "$HOME"

cp -r "$DIR/Scripts" "$HOME"

mkdir -p "$HOME/Development/git"

pushd $(pwd) > /dev/null

if [ -d "$HOME/Development/git/base16-gnome-terminal" ]; then
  cd "$HOME/Development/git/base16-gnome-terminal"
  git pull
else
  cd "$HOME/Development/git/"
  git clone "https://github.com/chriskempson/base16-gnome-terminal.git"
fi

if [ -d "$HOME/Development/git/base16-pantheon-terminal" ]; then
  cd "$HOME/Development/git/base16-pantheon-terminal"
  git pull
else
  cd "$HOME/Development/git/"
  git clone "https://github.com/charlesbjohnson/base16-pantheon-terminal.git"
fi

if [ -d "$HOME/Development/git/base16-shell" ]; then
  cd "$HOME/Development/git/base16-shell"
  git pull
else
  git clone "https://github.com/chriskempson/base16-shell.git"
fi

popd > /dev/null
