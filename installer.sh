#!/usr/bin/env bash

source /etc/lsb-release

if [ "$DISTRIB_ID" == "Arch" ];
then
  sudo pacman -S base-devel --noconfirm
  sudo pacman -S neovim erlang elixir ruby ruby-docs rust nodejs jre8-openjdk \
    jdk8-openjdk dart vala ghc haskell-hlint python-pyflakes ctags clang \
    clang-tools-extra git \
    --noconfirm
fi

if [ "$DISTRIB_ID" == "Solus" ];
then
  echo "Solus"
  sudo eopkg it -c -y system.devel
  sudo eopkg it -y kernel-headers ctags neovim elixir ghc rust cargo nodejs \
    openjdk-8 git
fi

mkdir -p "$HOME/Development/git"

pushd $(pwd) > /dev/null

cd "$HOME/Development/git"
git clone https://github.com/asonix/configs.git

DIR="$HOME/Development/git/configs"

# setup neovim
mkdir -p "$HOME/.config/nvim/autoload"
cp "$DIR/init.vim" "$HOME/.config/nvim/"

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

cp -r "$DIR/i3" "$HOME/.config"
cp -r "$DIR/i3status" "$HOME/.config"
cp "$DIR/.zshrc" "$HOME"
cp "$DIR/.zshenv" "$HOME"
cp "$DIR/.profile" "$HOME"
cp "$DIR/subtle.rb" "$HOME/.config"
cp "$DIR/compton.conf" "$HOME/.config"
cp "$DIR/.Xresources" "$HOME"

mkdir -p "$HOME/.local"
cp -r "$DIR/bin" "$HOME/.local"

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
  cd "$HOME/Development/git/"
  git clone "https://github.com/chriskempson/base16-shell.git"
fi

if [ -d "$HOME/Development/git/OSX-Arc-White" ]; then
  cd "$HOME/Development/git/OSX-Arc-White"
  git pull
else
  cd "$HOME/Development/git/"
  git clone "https://github.com/fusion809/OSX-Arc-White.git"
fi

sudo cp -r "$HOME/Development/git/OSX-Arc-White" /usr/share/themes/

sudo npm install -g elm
gsettings set org.gnome.desktop.interface gtk-theme 'OSX-Arc-White'
nvim -c PlugInstall -c qa
nvim -c PlugUpdate -c qa
nvim -c PlugUpgrade -c qa

popd > /dev/null
