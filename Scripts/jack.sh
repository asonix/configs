#!/usr/bin/env bash

ID=1
PROFILE="output:analog-surround-40+input:analog-stereo"
CONF="laptop"

ponymix list-cards | grep Focusrite

if [ $? -eq 0 ]; then
  ID=$(ponymix list-cards | grep Focusrite | cut -b 6)
  CONF="focusrite"
  PROFILE=$(ponymix list-cards | grep Focusrite -A 2 | grep Active | cut -c 19-)
else
  ID=$(ponymix list-cards | grep alsa_card.pci-0000_00_1b.0 | cut -b 6)
  PROFILE=$(ponymix list-cards | grep alsa_card.pci-0000_00_1b.0 -A 2 | grep Active | cut -c 19-)
fi

# Kill Telegram
echo "Killing Telegram"
killall Telegram

# Turn off card that will be used
echo "Turning off audio card $ID"
ponymix -c $ID set-profile off

# Copy jack config into correct location
echo "Copying jack config to ~/.jackdrc"
cp "$HOME/.config/jackdrc-$CONF" ~/.jackdrc


# Stop unneeded daemons
echo "Stopping daemons"
sudo systemctl stop bumblebeed bluetooth NetworkManager nmbd org.cups.cupsd smbd sshd tincd@. wpa_supplicant

# Let CPU run in performance mode
echo "Setting CPU to performance mode"
sudo cpupower frequency-set -g performance

# Launch jack
echo "Starting qjackctl"
qjackctl

# Let CPU run in performance mode
echo "Setting CPU to powersave mode"
sudo cpupower frequency-set -g powersave

# Stop daemons
echo "Starting daemons"
sudo systemctl start bumblebeed bluetooth NetworkManager nmbd org.cups.cupsd smbd sshd tincd@. wpa_supplicant

# Turn card back on
echo "Turning on audio card $ID"
ponymix -c $ID set-profile $PROFILE
