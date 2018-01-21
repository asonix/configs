# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

source "$HOME/.oh-my-zsh/custom/themes/spaceship.zsh-theme"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Base16 Shell
BASE16_SHELL="$HOME/Development/git/base16-shell/scripts/base16-eighties.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL

# Z
Z_SH="/usr/lib/z.sh"
[[ -s $Z_SH ]] && source $Z_SH

# Syntax highlighting
ZSH_SYNTAX_HIGHLIGHT="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [[ -s $ZSH_SYNTAX_HIGHLIGHT ]]; then
    source $ZSH_SYNTAX_HIGHLIGHT
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
else
    ZSH_SYNTAX_HIGHLIGHT_2="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    if [[ -s $ZSH_SYNTAX_HIGHLIGHT_2 ]]; then
        source $ZSH_SYNTAX_HIGHLIGHT_2
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    fi
fi

# Auto-suggest
ZSH_AUTOSUGGESTIONS="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -s $ZSH_AUTOSUGGESTIONS ]] && source $ZSH_AUTOSUGGESTIONS

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS

#-------------------
# Personnal Aliases
#-------------------

alias rust-arvm7h-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src messense/rust-musl-cross:armv7-musleabihf'
alias rust-amd64-musl-builder='docker run --rm -it -v "$(pwd)":/home/rust/src messense/rust-musl-cross:x86_64-musl'
alias mount='echo "aroo??"'
alias umount='echo "awwwww :c"'
alias unyiff='/bin/umount'
alias yiff='/bin/mount'

alias quickly='sudo'

alias testpl='echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"'

alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias classify='classify -d 30'
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias grep='grep --color=always'
alias pacman='pacman --color always'
alias pacaur='pacaur --color always'
alias ping='ping -c 4'

# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'

# Pretty-print of some PATH variables:
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'

#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------

extract()      # Handy Extract Program
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

ttyctl -f

# vim mode
bindkey -v

# completion bullshit
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion:*' menu select
setopt completealiases

if which rbenv > /dev/null 2> /dev/null; then eval "$(rbenv init -)"; fi
if which pyenv > /dev/null 2> /dev/null; then eval "$(pyenv init -)"; fi
if which exenv > /dev/null 2> /dev/null; then eval "$(exenv init -)"; fi

PROMPT="${PROMPT} "
PS2="${PS2}  "

# added by travis gem
[ -f /home/asonix/.travis/travis.sh ] && source /home/asonix/.travis/travis.sh
