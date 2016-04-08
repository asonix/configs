#!/usr/bin/env bash

function update {
  local="$1"
  remote="$2"

  git add .
  git commit -m "local changes"

  git checkout "$remote"
  git pull
  git checkout "$local"
  git merge "$remote"

  ./up.sh
}

cd ~/Development/git/repository/packages

update "riley-testing" "testing"
update "riley-custom" "testing"
update "riley-stable" "stable"

echo "done"
