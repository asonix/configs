#!/usr/bin/env bash

killall compton

i3lock -f &

sleep 0.2

while [ $(pidof i3lock) ]; do
  sleep 0.2
done

exec compton &
