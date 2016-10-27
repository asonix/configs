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

function aur_package() {
  cd /tmp
  curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
  tar zxvf $1.tar.gz
  cd $1
  makepkg -si --noconfirm
  cd /tmp
  rm -rf $1*
}

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
  sudo sed -i 's/#greeter-session=.*/greeter-session=lightdm-gtk-greeter/g' \
    /etc/lightdm/lightdm.conf
  sudo systemctl enable lightdm

  # UI Packages
  sudo pacman -S gnome budgie-desktop compton --noconfirm

  # Network setup
  sudo pacman -S networkmanager network-manager-applet \
    networkmanager-openconnect networkmanager-openvpn networkmanager-pptp \
    networkmanager-vpnc \
    --noconfirm
  sudo systemctl enable NetworkManager

  # Applications
  sudo pacman -S owncloud-client pantheon-terminal noise-player audience \
    contractor pantheon-files pantheon-photos scratch-text-editor geary \
    gnome-tweak-tool lightdm-gtk-greeter-settings \
    --noconfirm

  # Development Packages
  sudo pacman -S neovim erlang elixir ruby ruby-docs rust nodejs jre8-openjdk \
    jdk8-openjdk dart vala ghc haskell-hlint python-pyflakes ctags clang \
    clang-tools-extra git npm ccache ack zsh openssh zsh-syntax-highlighting \
    htop linux-headers \
    --noconfirm

  # AUR helper
  pushd $(pwd) > /dev/null

  cd /etc
  sudo sed -i 's/^CFLAGS=.*/CFLAGS="-march=native -O2 -pipe -fstack-protector-strong"/g' makepkg.conf
  sudo sed -i 's/^CXXFLAGS=.*/CXXFLAGS="\${CFLAGS}"/g' makepkg.conf
  sudo sed -i 's/#MAKEFLAGS=.*/MAKEFLAGS="-j4"/g' makepkg.conf

  cd ~/.gnupg
  sed -i 's/#keyserver-options.*/keyserver hkp:\/\/keys.gnupg.net\nkeyserver-options auto-key-retrieve/g' gpg.conf

  aur_package 'cower'
  aur_package 'pacaur'

  popd > /dev/null

  # i3-gaps
  pacaur -S i3-gaps --noconfirm

  # subtle-wm
  pacaur -S subtle-git --noconfirm

  # themes
  pacaur -S paper-icon-theme-git --noconfirm
  pacaur -S gtk-theme-arc-git --noconfirm

  # Telegram
  pacaur -S telegram-desktop --noconfirm

  # Chrome
  pacaur -S google-chrome --noconfirm

  # Z
  pacaur -S z-git --noconfirm
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

if [ "$ID" == "arch" ]; then
  pacaur -S osx-arc-white-git --noconfirm
  pacaur -S ttf-monofur-powerline-git --noconfirm
  pacaur -S ttf-fantasque-sans --noconfirm
else
  git_package 'OSX-Arc-White' 'fusion809' 'git'
  sudo cp -r "$HOME/Development/git/OSX-Arc-White" /usr/share/themes/

  # Fonts
  git_package 'ttf-monofur-powerline' 'rsrsl' 'git'
  sudo cp "$HOME/Development/git/ttf-monofur-powerline/*.ttf" /usr/share/fonts/TTF

  cd "$HOME/Downloads"
  curl -O 'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/b0cbb25e73a9f8354e96d89524f613e7/fantasque-sans-mono.zip'
  unzip fantasque-sans-mono.zip
  sudo cp "$HOME/Downloads/fantasque-sans-mono/*.ttf" /usr/share/fonts/TTF

  sudo fc-cache
fi

# Install Elm
sudo npm install -g elm

bash set_configs.sh "$HOME/Development/git/configs"

popd > /dev/null
