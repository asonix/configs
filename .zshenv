export XDG_CONFIG_HOME=~/.config
export XDG_DATA_HOME=~/.config
export LANG=en_US.UTF-8

export DEFAULT_USER=asonix

# enable ribbon in libreoffice
export LO_USE_NOTEBOOKBAR=1

export EDITOR=nvim
export BROWSER=firefox

export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"

typeset -U path
path=(/root/.gem/ruby/2.2.0/bin ~/.node_modules_global/bin ~/Development/git/flutter/bin $(ruby -e 'print Gem.user_dir')/bin ~/.local/bin ~/.cargo/bin $path[@])
