#!/usr/bin/env bash

function get_pkg_info {
  _pkgname="$(cat $1/PKGBUILD | grep -m 1 _pkgname= | cut -d = -f 2)"
  pkgver="$(cat $1/PKGBUILD | grep -m 1 pkgver= | cut -d = -f 2)"

  if [[ -z $_pkgname ]]
  then
    pkgname="$(cat $1/PKGBUILD | grep pkgname= | cut -d = -f 2)"
  else
    pkgname=$_pkgname-git
  fi

  if [ ! -z "$2" ]
  then
    pkgname="$2"
  fi

  commit_message="Updated to $pkgver"
}

function create_pkg {
  pushd $(pwd) > /dev/null

  mkdir -p ~/.papyros-aur
  cd ~/.papyros-aur

  echo "Continue creating new package $pkgname? (y/n)"
  read cont

  if [ $cont == 'Y' ] || [ $cont == 'y' ]
  then
    echo "Creating $pkgname in AUR4..."
    ssh aur@aur4.archlinux.org setup-repo $pkgname

    echo "Cloning $pkgname.git from AUR4..."
    git clone ssh://aur@aur4.archlinux.org/$pkgname.git

    popd > /dev/null

    commit_message="Initial Import"
  else
    popd > /dev/null

    echo "Editing PKGBUILD..."
    vim $1/PKGBUILD

    echo "Restart creating new package $pkgname? (y/n)"
    read rst

    if [ $rst == "y" ] || [ $rst == "Y" ]
    then
      get_pkg_info $1 $2

      create_pkg $1 $2
    fi
  fi
}

function push_pkg {
  cmp -s $1/PKGBUILD ~/.papyros-aur/$pkgname/PKGBUILD >/dev/null
  if [ ! $? -eq 0 ]; then

    cp $1/* ~/.papyros-aur/$pkgname/

    pushd $(pwd) > /dev/null

    cd ~/.papyros-aur/$pkgname

    mksrcinfo

    if [ -z "$commit_message" ]
    then
      commit_message="updated something"
    fi

    echo "Pushing from $(pwd)..."
    git add .
    git commit -am "$commit_message"
    git push origin master

    popd > /dev/null
  fi

}

function update_pkg {
  if grep -Fq "<<<<<<<" $1/PKGBUILD
  then
    vim $1/PKGBUILD
  fi

  get_pkg_info $1 $2

  if ! [ -d ~/.papyros-aur/$pkgname ]; then create_pkg $1 $2; fi

  if [ -d ~/.papyros-aur/$pkgname ]; then push_pkg $1; fi

}

update_pkg "$1" "$2"
