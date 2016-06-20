#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

function rcd {
  tempfile='/tmp/ranger-cd'
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}
function _rcdw {
    BUFFER="rcd"
    zle accept-line
}
zle -N _rcdw

export PATH=$PATH:$HOME/.cask/bin:$HOME/.pyenv/bin:$HOME/bin
export WORKON_HOME=~/virtenvs
export VIRTUALENVWRAPPER_WORKON_CD=1
source /usr/local/bin/virtualenvwrapper.sh

export EDITOR="vim"
bindkey -v
export KEYTIMEOUT=1
bindkey '^[[1;2C' forward-word
bindkey '^[[1;2D' backward-word

# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word
bindkey '^[[3;5~' kill-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
# ranger-cd
bindkey "^O" _rcdw

# ignore double esc
noop () { }
zle -N noop
bindkey -M vicmd '\e' noop

setopt AUTO_CD
setopt AUTO_PUSHD
setopt GLOB_COMPLETE
setopt PUSHD_MINUS
setopt PUSHD_TO_HOME
setopt PUSHD_IGNORE_DUPS
setopt NO_HUP
setopt NO_CLOBBER
setopt NO_CASE_GLOB
setopt NUMERIC_GLOB_SORT
setopt EXTENDED_GLOB
setopt AUTO_LIST

ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'

# source ~/.tmuxinator/tmuxinator.zsh

bindkey '^B' push-line

# vi style incremental search
bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward
# bindkey '^P' history-search-backward
# bindkey '^N' history-search-forward

alias em="emacs -nw"
alias v="vim"
alias sv="sudo vim"

alias extract="aunpack"

alias tmux="tmux -2"
alias tm="tmux"
alias tml="tmux list-sessions"
alias tma="tmux attach-session"
alias tmd="tmux detach-client"
alias tmkw="tmux kill-window"
alias tmkp="tmux kill-pane"
alias tmks="tmux kill-session"
alias tmr="tmux resize-pane"
alias tmrl="tmux resize-pane -L"
alias tmrr="tmux resize-pane -R"

alias ga="git add"
alias gaa="git add -u"
alias gb="git branch"
alias gbi="git bisect"
alias gbib="git bisect bad"
alias gbig="git bisect good"
alias gbl="git blame"
alias gc="git commit --signoff"
alias gch="git checkout"
alias gcherry="git cherry-pick"
function gchpr(){git fetch $1 refs/pull/$2/head:pr/$2 && git checkout pr/$2;}
alias gclean="git clean -f"
alias gclon="git clone"
alias gd="git diff"
alias gdt="git difftool"
alias gf="git fetch"
function gfpr(){git fetch $1 refs/pull/$2/head:pr/$2;}
alias ggrep="git grep"
alias ginit="git init"
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --stat"
alias glast="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --stat -1"
alias glo="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gm="git merge"
alias gmt="git mergetool"
alias gmv="git mv"
alias gp="git push"
alias gpatch="git format-patch --signoff"
alias gpull="git pull"
alias greb="git rebase"
alias grem="git remote"
alias gres="git reset"
alias gresh="git reset --hard"
alias gress="git reset --soft"
alias grev="git revert"
alias grm="git rm"
alias grmc="git rm --cached"
alias gs="git status -sb"
alias gsend="git send-email"
alias gsh="git show"
alias gst="git stash"

unalias gcl
unalias gcm
function gcm() {
    git commit -m "$*"
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias inst="sudo apt-get install"
alias rmf="rm -rf"
alias r="ranger"
function mkcd() {
    command mkdir $1 && cd $1
}
eval $(thefuck --alias)
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

curdate=$(date +%m/%d/%y)
if [[ ! -e ~/.last_fortune || $(cat ~/.last_fortune) != $curdate ]]; then
    echo $curdate >! ~/.last_fortune
    COWSTYLES="bdgpstwy"
    RANDCOW=$[ ( $RANDOM % 9 ) ]
    if [[ $RANDCOW > 0 ]]; then
        COWSTYLE="-${COWSTYLES[$RANDCOW]}"
    else
        COWSTYLE=""
    fi
    fortune | cowsay $COWSTYLE
fi
