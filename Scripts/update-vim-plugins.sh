#!/usr/bin/env bash

cd ~/.vim/bundle

for i in $( ls ); do
  if [ -d $i ]; then
    cd $i
    git pull
    cd ..
  fi
done
