export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.config
export LANG=en_US.UTF-8

export HACHIMAN="30:85:A9:9A:C7:A2"

# enable ribbon in libreoffice
export LO_USE_NOTEBOOKBAR=1

export PANEL_FIFO=/tmp/panel.fifo
export EDITOR=nvim
export BROWSER=chromium
# export PATH="~/Scripts:$PATH"
export VST_PATH="/usr/lib/vst:/usr/local/lib/vst:~/.vst:/media/windows-data/VST"

typeset -U path
path=(/root/.gem/ruby/2.2.0/bin ~/Development/JavaScript/.npm-global/bin ~/Development/git/flutter/bin $(ruby -e 'print Gem.user_dir')/bin ~/Scripts $path[@])

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

# if [ -n "$DESKTOP_SESSION" ]; then
#   eval $(gnome-keyring-daemon --start)
#   export SSH_AUTH_SOCK
# fi
