#!/usr/bin/env bash

function git_package() {
  if [ -d "$HOME/Development/$3/$1" ]; then
    cd "$HOME/Development/$3/$1"
    git pull
  else
    cd "$HOME/Development/$3/"
    git clone "https://github.com/$2/$1"
  fi
}

CONFIG_DIR=$1

if [ "$CONFIG_DIR" == "" ]; then CONFIG_DIR="$HOME/Development/git/configs"; fi

# Neovim
mkdir -p "$HOME/.config/nvim/autoload"
cp "$CONFIG_DIR/init.vim" "$HOME/.config/nvim/"

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim Plug
nvim -c PlugInstall -c qa
nvim -c PlugUpdate -c qa
nvim -c PlugUpgrade -c qa

# Configs
cp -r "$CONFIG_DIR/i3" "$HOME/.config"
cp -r "$CONFIG_DIR/i3status" "$HOME/.config"
cp "$CONFIG_DIR/.zshrc" "$HOME"
cp "$CONFIG_DIR/.zshenv" "$HOME"
cp "$CONFIG_DIR/.profile" "$HOME"
cp "$CONFIG_DIR/subtle.rb" "$HOME/.config"
cp "$CONFIG_DIR/compton.conf" "$HOME/.config"
cp "$CONFIG_DIR/.Xresources" "$HOME"

# Shell Scripts
mkdir -p "$HOME/.local"
cp -r "$CONFIG_DIR/bin" "$HOME/.local"

# Base16 Color Schemes
git_package 'base16-gnome-terminal' 'chriskempson' 'git'
cd "$HOME/Development/git/base16-gnome-terminal"
bash base16-eighties.dark.sh

git_package 'base16-pantheon-terminal' 'charlesbjohnson' 'git'
cd "$HOME/Development/git/base16-pantheon-terminal"
bash base16-eighties.dark.sh

git_package 'base16-shell' 'chriskempson' 'git'

# Wallpaper Rotation
mkdir -p "$HOME/Development/cpp"
git_package 'gnome-background-rotation' 'asonix' 'cpp'

# Set Themes
gsettings set org.gnome.desktop.interface icon-theme 'Paper'
gsettings set org.gnome.desktop.interface gtk-theme 'OSX-Arc-White'

gsettings set com.solus-project.budgie-helper.workarounds fix-button-layout 'close,minimize,maximize:menu'
gsettings set com.solus-project.budgie-wm button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome.shell.extensions.classic-overrides button-layout 'close,minimize,maximize:appmenu'

gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark'

gsettings set org.pantheon.terminal.settings cursor-color '#555555'
gsettings set org.pantheon.terminal.settings background 'rgba(45, 45, 45, 0.98)'
gsettings set org.pantheon.terminal.settings follow-last-tab true
gsettings set org.pantheon.terminal.settings natural-copy-paste false
gsettings set org.pantheon.terminal.settings tab-bar-behavior 'Hide When Single Tab'
gsettings set org.pantheon.terminal.settings font 'fantasque sans mono 12'
