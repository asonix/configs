XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

# export english/us/utf8 as language env variable
export LANG=en_US.UTF-8

export DEFAULT_USER=$(whoami)

if ! pgrep -u $USER ssh-agent > /dev/null; then
  ssh-agent > ~/.config/ssh-agent-status

  if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.config/ssh-agent-status) > /dev/null
    ssh-add $(ls ~/.ssh | while read line; do echo "$HOME/.ssh/$line"; done | grep -v .pub | grep id_rsa) > /dev/null
  fi
else
  if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval $(<~/.config/ssh-agent-status) > /dev/null
  fi
fi

# cd Development/git/xSwipe
# perl xSwipe.pl -n &
# cd

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true

ssh-add -l > /dev/null || alias ssh='ssh-add -l > /dev/null || ssh-add && unalias ssh; ssh'
