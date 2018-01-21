#!/usr/bin/env bash

while [ $(pidof i3 || pidof subtle) ]; do
  find ~/Pictures/wallpapers -type f \( -name '*.png' \) -print0 | shuf -n1 -z |
    {
      WALLPAPER=$(xargs -0)
      echo $WALLPAPER > ~/.config/wallpath
      feh --bg-fill "$WALLPAPER"
    }
  sleep 15m
done
