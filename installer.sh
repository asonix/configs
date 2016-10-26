#!/usr/bin/env bash

LSB_RELEASE=/etc/lsb-release
OS_RELEASE=/etc/os-release

if [ -f "$LSB_RELEASE" ]; then source $LSB_RELEASE; fi
if [ -f "$OS_RELEASE" ]; then source $OS_RELEASE; fi

if [ "$ID" == "arch" ]
then
  # Base Development packages
  sudo pacman -S base-devel --noconfirm

  # Xorg packages
  sudo pacman -S xorg-server xorg-server-utils xorg-drivers --noconfirm

  # Greeter packages
  sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm
  sed -i 's/#greeter-session=.*/greeter-session=lightdm-gtk-greeter/g' \
    /etc/lightdm/lightdm.conf
  sudo systemctl enable lightdm

  # UI Packages
  sudo pacman -S gnome budgie-desktop --noconfirm

  # Network setup
  sudo pacman -S networkmanager network-manager-applet \
    networkmanager-openconnect networkmanager-openvpn networkmanager-pptp \
    networkmanager-vpnc \
    --noconfirm
  sudo systemctl enable NetworkManager

  # Applications
  sudo pacman -S owncloud-client pantheon-terminal noise-player audience \
    contractor pantheon-files pantheon-photos scratch-text-editor geary \
    htop zsh gnome-tweak-tool openssh \
    --noconfirm

  # Development Packages
  sudo pacman -S neovim erlang elixir ruby ruby-docs rust nodejs jre8-openjdk \
    jdk8-openjdk dart vala ghc haskell-hlint python-pyflakes ctags clang \
    clang-tools-extra git npm ccache ack \
    --noconfirm

  # AUR helper
  pushd $(pwd) > /dev/null

  cd /etc
  sed -i 's/^CFLAGS=.*/CFLAGS="-march=native -02 -pipe -fstack-protector-strong"/g' makepkg.conf
  sed -i 's/^CXXFLAGS=.*/CXXFLAGS="\${CFLAGS}"/g' makepkg.conf
  sed -i 's/#MAKEFLAGS=.*/MAKEFLAGS="-j4"/g' makepkg.conf

  cd ~/.gnupg
  sed -i 's/#keyserver-options.*/keyserver hkp:\/\/keys.gnupg.net\nkeyserver-options auto-key-retrieve/g' gpg.conf

  cd /tmp
  curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz
  tar zxvf cower.tar.gz
  cd cower
  makepkg -si --noconfirm
  cd /tmp
  rm -rf cower*

  cd /tmp
  curl -O https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz
  tar zxvf pacaur.tar.gz
  cd pacaur
  makepkg -si --noconfirm
  cd /tmp
  rm -rf pacaur*
  popd > /dev/null

  # i3-gaps
  pacaur -S i3-gaps --noconfirm

  # subtle-wm
  pacaur -S subtle-git --noconfirm

  # themes
  pacaur -S paper-icon-theme-git --noconfirm
  pacaur -S gtk-theme-arc-git --noconfirm
fi

if [ "$DISTRIB_ID" == "Solus" ];
then
  # Base development packages
  sudo eopkg it -c -y system.devel

  # Applications
  sudo eopkg it -y owncloud-client geary feedreader zsh

  # Development Packages
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

mkdir -p "$HOME/Development/cpp"
if [ -d "$HOME/Development/cpp/gnome-background-rotation" ]; then
  cd "$HOME/Development/cpp/gnome-background-rotation"
  git pull
else
  cd "$HOME/Development/cpp/"
  git clone "https://github.com/asonix/gnome-background-rotation.git"
fi

if [ "$ID" == "arch" ]; then
  pacaur -S osx-arc-white-git --noconfirm
else
  if [ -d "$HOME/Development/git/OSX-Arc-White" ]; then
    cd "$HOME/Development/git/OSX-Arc-White"
    git pull
  else
    cd "$HOME/Development/git/"
    git clone "https://github.com/fusion809/OSX-Arc-White.git"
  fi
  sudo cp -r "$HOME/Development/git/OSX-Arc-White" /usr/share/themes/
fi

# Install Elm
sudo npm install -g elm

# Set Themes
gsettings set org.gnome.desktop.interface gtk-theme 'OSX-Arc-White'
gsettings set com.solus-project.budgie-helper.workarounds fix-button-layout 'close,minimize,maximize:menu'
gsettings set com.solus-project.budgie-wm button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome.shell.extensions.classic-overrides button-layout 'close,minimize,maximize:appmenu'
gsettings set org.gnome.desktop.interface icon-theme 'Paper'
gsettings set org.gnome.shell enabled-extensions "['user-theme@gnome-shell-extensions.gcampax.github.com']"
gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark'
gsettings set org.pantheon.terminal.settings background 'rgba(45, 45, 45, 0.98)'
gsettings set org.pantheon.terminal.settings follow-last-tab true
gsettings set org.pantheon.terminal.settings natural-copy-paste false
gsettings set org.pantheon.terminal.settings tab-bar-behavior 'Hide When Single Tab'

# Setup Vim Plug
nvim -c PlugInstall -c qa
nvim -c PlugUpdate -c qa
nvim -c PlugUpgrade -c qa

popd > /dev/null
