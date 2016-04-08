#!/usr/bin/env bash

# I need to evaluate symlinks because i'm linking to this script in $HOME/Scripts
SOURCE="${BASH_SOURCE}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, it needs to be resolved
done
DIR="$( cd "$( dirname "$SOURCE}" )" && pwd )"

cp -r "$HOME/.config/i3" "$DIR" # copy i3 config
cp -r "$HOME/.config/i3status" "$DIR" # copy i3status config
cp -r "$HOME/.zsh*" "$DIR" # copy zsh configs
cp -r "$HOME/.profile" "$DIR" # copy profile
cp "$HOME/.config/nvim/init.vim" "$DIR" # copy nvim config
cp "$HOME/.config/subtle.rb" "$DIR" # copy subtle config
cp "$HOME/.config/compton.conf" "$DIR" # copy compton config
cp "$HOME/.Xresources" "$DIR" # copy xterm and urxvt configs

cp -r "$HOME/Scripts" "$DIR" # copy scripts

pushd $(pwd) > /dev/null

cd "$DIR"

git add .
git commit -m "Updated Configs"
git push

popd > /dev/null

