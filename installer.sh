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

function pacman_packages() {
  for pkg in $@; do
    if pacman -Q $pkg > /dev/null 2> /dev/null; then
      echo "$pkg already installed"
    else
      sudo pacman -S $pkg --noconfirm
    fi
  done
}

function pacaur_packages() {
  for pkg in $@; do
    if pacman -Q $pkg > /dev/null 2> /dev/null; then
      echo "$pkg already installed"
    else
      pacaur -S $pkg --noconfirm
    fi
  done
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
  pacman_packages xorg-server xorg-server-utils xorg-drivers

  # Greeter packages
  pacman_packages lightdm lightdm-gtk-greeter
  sudo sed -i 's/#greeter-session=.*/greeter-session=lightdm-gtk-greeter/g' \
    /etc/lightdm/lightdm.conf
  sudo systemctl enable lightdm

  # UI Packages
  pacman_packages gnome budgie-desktop compton

  # Network setup
  pacman_packages networkmanager network-manager-applet \
    networkmanager-openconnect networkmanager-openvpn networkmanager-pptp \
    networkmanager-vpnc
  sudo systemctl enable NetworkManager

  # Applications
  pacman_packages owncloud-client pantheon-terminal noise-player audience \
    contractor pantheon-files pantheon-photos scratch-text-editor geary \
    gnome-tweak-tool lightdm-gtk-greeter-settings \
    --noconfirm

  # Development Packages
  pacman_packages neovim erlang elixir ruby ruby-docs rust nodejs jre8-openjdk \
    jdk8-openjdk dart vala ghc haskell-hlint python-pyflakes ctags clang \
    clang-tools-extra git npm ccache ack zsh openssh zsh-syntax-highlighting \
    htop linux-headers

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
  pacaur_packages i3-gaps alsa-utils dmenu i3lock i3status light scrot \
    polkit-gnome playerctl

  # subtle-wm
  pacaur_packages subtle-git

  # Telegram
  pacaur_packages telegram-desktop

  # Chrome
  pacaur_packages google-chrome

  # Z
  pacaur_packages z-git

  # themes
  pacaur_packages breeze-snow-cursor-theme paper-icon-theme-git \
    gtk-theme-arc-flatabulous-git plank-theme-arc arc-icon-theme arc-gtk-theme \

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

pushd $(pwd) > /dev/null

git_package 'configs' 'asonix' "$HOME/Development/git"
cd "$HOME/Development/git"

if [ "$ID" == "arch" ]; then
  pacaur_packages ttf-monofur-powerline-git ttf-fantasque-sans
else
  git_package 'arc-flatabulous-theme' 'andreisergiu98' "$HOME/Development/git"
  cd "$HOME/Development/git/arc-flatabulous-theme"
  ./autogen.sh --prefix=/usr
  sudo make install

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
