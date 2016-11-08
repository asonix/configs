#!/usr/bin/env bash

for pkg in $(pacman -Q | grep 'pantheon\|elementary\|switchboard\|wingpanel' --color=never | cut -d ' ' -f 1); do
  yaourt -S aur/$pkg
done
