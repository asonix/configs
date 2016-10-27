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

function aur_package() {
  PKG="$1"

  if [ "$PKG" != "" ]; then
    cd /tmp
    curl -O "https://aur.archlinux.org/cgit/aur.git/snapshot/$PKG.tar.gz"
    tar zxvf "$PKG.tar.gz"
    cd "/tmp/$PKG"
    makepkg -si --noconfirm
    cd /tmp
    rm -rf "/tmp/$PKG*"
  fi
}

function deb_package() {
  URL="$1"
  cd /tmp
  curl -O "$URL"
  sudo dpkg -i *.deb
  rm -f *.deb
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

  # Breeze Snow cursor theme
  pacaur -S breeze-snow-cursor-theme --noconfirm

  # Icon themes
  cd /usr/share/icons/default
  sudo sed -i 's/Adwaita/Breeze_Snow/g' index.theme
fi

if [ "$ID" == "elementary" ];
then
  sudo apt update
  sudo apt install software-properties-common

  # Dev Packages
  sudo apt install apt-transport-https
  sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
  sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
  deb_package "https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_19.1.3-1~ubuntu~xenial_amd64.deb"
  sudo add-apt-repository -y ppa:neovim-ppa/unstable
  curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
  sudo apt update
  sudo apt install -y elixir build-essential ghc hlint nodejs rustc cargo \
    neovim htop zsh openjdk-9-jdk openjdk-9-jre dart valac exuberant-ctags \
    clang ack-grep ssh zsh-syntax-highlighting

  # Applications
  sudo apt-add-repository -y ppa:atareao/telegram
  sudo apt update
  sudo apt install -y telegram owncloud-client
fi

if [ "$DISTRIB_ID" == "Solus" ];
then
  # Base development packages
  sudo eopkg it -c -y system.devel

  # Applications
  sudo eopkg it -y owncloud-client geary feedreader

  # Development Packages
  sudo eopkg it -y kernel-headers ctags neovim elixir ghc rust cargo nodejs \
    openjdk-8 git zsh htop
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
  git_package 'OSX-Arc-White' 'fusion809' "$HOME/Development/git"
  sudo cp -r "$HOME/Development/git/OSX-Arc-White" /usr/share/themes/

  # Fonts
  git_package 'ttf-monofur-powerline' 'rsrsl' "$HOME/Development/git"
  sudo cp "$HOME/Development/git/ttf-monofur-powerline/*.ttf" /usr/share/fonts/TTF

  cd "$HOME/Downloads"
  curl -O 'https://fontlibrary.org/assets/downloads/fantasque-sans-mono/b0cbb25e73a9f8354e96d89524f613e7/fantasque-sans-mono.zip'
  unzip fantasque-sans-mono.zip
  sudo cp "$HOME/Downloads/fantasque-sans-mono/*.ttf" /usr/share/fonts/TTF

  sudo fc-cache
fi

# Install Elm
sudo npm install -g elm

cd "$HOME/Development/git/configs"
bash set_configs.sh "$HOME/Development/git/configs"

popd > /dev/null
