#!/usr/bin/env bash

function git_package() {
  DIR="$3"
  PKG="$1"
  USER="$2"

  mkdir -p "$DIR"
  if [ -d "$DIR/$PKG" ]; then
    cd "$DIR/$PKG"
    git pull
  else
    cd "$DIR"
    git clone "https://github.com/$USER/$PKG"
  fi
}

CONFIG_DIR=$1

source /etc/os-release

if [ "$CONFIG_DIR" == "" ]; then CONFIG_DIR="$HOME/Development/git/configs"; fi

# Neovim
mkdir -p "$HOME/.config/nvim/autoload"
cp "$CONFIG_DIR/init.vim" "$HOME/.config/nvim/"

curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Vim Plug
nvim \
  -c PlugInstall \
  -c PlugUpdate \
  -c PlugUpgrade \
  -c qa

# Configs

if [ "$ID" != "elementary" ]; then
  cp -r "$CONFIG_DIR/i3" "$HOME/.config"
  cp -r "$CONFIG_DIR/i3status" "$HOME/.config"
fi

cp "$CONFIG_DIR/.zshrc" "$HOME"
cp "$CONFIG_DIR/.zshenv" "$HOME"
cp "$CONFIG_DIR/.profile" "$HOME"

if [ "$ID" == "arch" ]; then
  cp "$CONFIG_DIR/subtle.rb" "$HOME/.config"
  cp "$CONFIG_DIR/compton.conf" "$HOME/.config"
fi

cp "$CONFIG_DIR/.Xresources" "$HOME"

# Shell Scripts
mkdir -p "$HOME/.local"
cp -r "$CONFIG_DIR/bin" "$HOME/.local"

# Base16 Color Schemes
git_package 'base16-gnome-terminal' 'chriskempson' "$HOME/Development/git"
cd "$HOME/Development/git/base16-gnome-terminal"
bash base16-eighties.dark.sh

git_package 'base16-pantheon-terminal' 'charlesbjohnson' "$HOME/Development/git"
cd "$HOME/Development/git/base16-pantheon-terminal"
bash base16-eighties.dark.sh

git_package 'base16-shell' 'chriskempson' "$HOME/Development/git"

if [ "$ID" != "solus" ]; then
  # Wallpaper Rotation
  git_package 'gnome-background-rotation' 'asonix' "$HOME/Development/cpp"
fi

# Set Themes
if [ "$ID" != "elementary" ]; then
  gsettings set org.gnome.desktop.interface icon-theme 'Paper'
  gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Flatabulous-Darker'

  gsettings set com.solus-project.budgie-helper.workarounds fix-button-layout 'close,minimize,maximize:menu'
  gsettings set com.solus-project.budgie-wm button-layout 'close,minimize,maximize:appmenu'
  gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
  gsettings set org.gnome.shell.extensions.classic-overrides button-layout 'close,minimize,maximize:appmenu'

  gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
  gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark'
fi

# Terminal Config
gsettings set org.pantheon.terminal.settings cursor-color '#555555'
gsettings set org.pantheon.terminal.settings background 'rgba(45, 45, 45, 0.98)'
gsettings set org.pantheon.terminal.settings follow-last-tab true
gsettings set org.pantheon.terminal.settings natural-copy-paste false
gsettings set org.pantheon.terminal.settings unsafe-paste-alert false

if [ "$ID" == "elementary" ]; then
  gsettings set org.pantheon.terminal.settings font 'monofur for powerline 12'
  gsettings set org.pantheon.terminal.settings tab-bar-behavior 'Always Show Tabs'
elif [ "$ID" == "solus" ]; then
  gsettings set org.pantheon.terminal.settings font 'monofur for powerline 12'
  gsettings set org.pantheon.terminal.settings tab-bar-behavior 'Hide When Single Tab'
else
  gsettings set org.pantheon.terminal.settings font 'fantasque sans mono 12'
  gsettings set org.pantheon.terminal.settings tab-bar-behavior 'Hide When Single Tab'
fi
