# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Run Fasd
unalias d
alias d="dirs -v"
alias z='fasd_cd -d'
alias zz='fasd_cd -d -i'

# a and f
alias ag="rg --no-line-number"

alias f="fd -p -H"
alias c="bat"
alias q="br" # broot
alias xc="noglob xc"
alias p="pyp"

function dush() {
    args=("${@[@]}")
    if [[ $# == 0 ]]; then
        args=(".")
    fi
    for d in $args; do
        du -h -d 1 --all "$d" 2>/dev/null | sort -h -r | grep -v '^0\s'
    done
}

function _cdf() {
    found=$(f $@)
    if [[ $? -eq 0 ]]; then
        echo $found | while read res; do
            if [[ -d "$res" ]]; then
                cd "$res"
                return 0
            fi
        done
        return 1
    else
        return $?
    fi
}
alias cdf='noglob _cdf'
function cdb() {
    cd "$(dirname $1)"
}
alias ff='fasd -f'
alias fv='fasd -f -t -e ${EDITOR:-vim} -b viminfo'
alias vt='v $(fzf --multi --reverse)'
function _vf() {
    found=$(f $@)
    if [[ $? -eq 0 ]]; then
        onlyfiles=()
        echo $found | while read i; do
            ftype=$(file -bL --mime "$i")
            if [[ -f "$i" && ((! "$ftype" =~ "binary" ) || "$ftype" =~ "x-empty") ]]; then
                onlyfiles+=($i)
            fi
        done
        if [[ -z "$onlyfiles" ]]; then
            return 1
        fi
        [[ -n "$onlyfiles" ]] && ${EDITOR:-vim} ${onlyfiles}
    else
        return $?
    fi
}
alias vf='noglob _vf'
alias a='RIPGREP_CONFIG_PATH=$HOME/.ripgreprc rg --ignore-file=$HOME/.agignore'
function va() {
    lastparam=""
    for param in $@; do
        if [[ $param[1] != "-" || lastparam == "--" ]]; then break; fi
        lastparam=$param
    done
    found=$(a -l $@)
    if [[ $? -eq 0 ]]; then
        [[ -n "$found" ]] && ${EDITOR:-vim} "+silent!/$param" ${(f)found}
        return 0
    else
        return $?
    fi
}

function fa() {
    pat="$@"
    if [ "$#" -lt 1 ]; then pat=''; fi
    files=$(rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color always "$pat" 2>/dev/null | fzf --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}')
    [[ -n "$files" ]] && ${EDITOR:-vim} ${(f)files}
}

function psa() {
    psres=$(ps axk -%cpu o user,pid,pgid,%cpu,%mem,rss,stat,start,time,command)
    for i in $@; do
        psres=$(echo "$psres" | grep -a "$i")
    done
    echo $psres
}
function kpsa() {
    psa $@ | awk '{print $2}' | xargs kill
}
function kp() {
    pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

function x() {
    for i in $@; do
        fout=$(echo "$i" | rev | cut -f 2- -d '.' | rev)
        if [[ -f "$fout" ]]; then
            fout="$i.out"
        fi
        7z x "-o$fout" "$i"
    done
}

function dush() {
    if [[ $# -eq 0 ]]; then
        args=$(/bin/ls -A -1)
    else
        args=$(printf '%s\n' "${@[@]}")
    fi
    echo "$args" | xargs -d '\n' du -s --block-size=M | sort -n -r
}

# rcd
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

export GOPATH=$HOME/workspace/go
export GOBIN=$HOME/workspace/go/bin
export WORKON_HOME=$HOME/virtenvs
export PROJECT_HOME=$HOME/workspace
export PATH=$PATH:$HOME/.rvm/bin:$HOME/.pyenv/bin:$HOME/.yarn/bin:$HOME/bin:$HOME/.local/bin:$GOBIN:$HOME/bin/fzf/bin
if [[ -e $HOME/lib ]]; then
    export LD_LIBRARY_PATH=$HOME/lib
fi
export LESS="-Ri"

# fzf
[[ $- == *i* ]] && source "$HOME/bin/fzf/shell/completion.zsh" 2> /dev/null
source "$HOME/.fzf/shell/key-bindings.zsh"

export EDITOR="nvim"
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
# edit command line
bindkey -M vicmd v edit-command-line

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
# bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward
# bindkey '^P' history-search-backward
# bindkey '^N' history-search-forward

unalias rm
alias rm="nocorrect rm -I"
setopt rm_star_silent

alias em="emacs -nw"
alias v="${EDITOR:-vim}"
alias vl="${EDITOR:-vim} -u ~/.vimlessrc -"
alias gv="gvim"
alias sv="sudo ${EDITOR:-vim}"
function vout() {
    tmpfile=$(mktemp)
    if [[ $# -eq 1 ]]; then
        if [[ "$1" == "-" ]]; then
            cat >! "$tmpfile"
        else
            /bin/cp "$1" "$tmpfile"
        fi
    fi
    v "$tmpfile" > /dev/tty
    stty -F /dev/tty sane
    cat "$tmpfile"
    rm "$tmpfile"
}
alias new="i3-sensible-terminal ."

alias extract="aunpack"
alias xcopy="xclip -selection clipboard"
alias xpaste="xclip -selection clipboard -o"

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

alias dke='dk exec -it $(dk ps -ql -f status=running)'
alias dkr='dk run --rm -it'

alias ga="git add"
alias gaa="git add -u"
alias gb="git branch"
alias gbi="git bisect"
alias gbin="git bisect bad"
alias gbiy="git bisect good"
alias gbl="git blame -s"
alias gc="git commit --signoff -S"
alias gca="git commit --amend --signoff -S"
alias gcaa="git commit --amend --no-edit --signoff -S"
alias gch="git checkout"
alias gcherry="git cherry-pick"
function gchpr(){git fetch $1 refs/pull/$2/head:pr/$2 && git checkout pr/$2;}
function gchmr(){git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2}
alias gclean="git clean -f"
alias gclon="git clone"
alias gd="git diff"
alias gdrop="git stash --patch && git stash drop"
alias gds="git diff --staged"
alias gdt="git difftool"
alias gf="git fetch"
function gfpr(){git fetch $1 refs/pull/$2/head:pr/$2;}
alias ggrep="git grep"
alias ginit="git init"
alias gkeep="git add -i . && git stash -k && git stash drop && git reset"
alias gl="git log --topo-order --stat --pretty=format:\"${_git_log_medium_format}\""
alias glast="git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --stat -1 | cat"
alias glo="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gloo="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches HEAD"
alias gls="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --branches --stat"
alias gm="git merge"
alias gmt="git mergetool"
alias gmv="git mv"
alias gp="git push"
alias gpatch="git format-patch --signoff"
alias gpf="git push -f"
alias gpull="git pull"
alias greb="git rebase"
alias greba="git rebase --abort"
alias grebc="git rebase --continue"
alias grebi="git rebase -i"
alias greflog="git reflog --color --walk-reflogs --pretty=format:'%Cred%h%Creset %C(magenta)%gD%Creset -%C(yellow)%d%Creset %gs %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias grem="git remote -v"
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
alias gsti="git stash --patch"
function gundo() {git reset --hard $(git rev-parse --abbrev-ref HEAD)@\{${1-1}\};}

unalias gcl
unalias gcm
function gcm() {
    git commit --signoff -S -m "$*"
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias diff="colordiff"
alias inst="sudo apt-get install"
alias rmf="rm -rf"
alias r="ranger"
alias wl="wunderline"
alias path="readlink -f"
function mkcd() {
    command mkdir -p $1 && cd $1
}
# Wunderline remind in hours / days
function wldh() {
    wldate=$(python -c "import sys; from datetime import datetime, timedelta;
d = datetime.now() + timedelta(days=$1, hours=$2);
sys.stderr.write('Reminder on: {}\n'.format(d.strftime('%A %Y-%m-%d %H:%M')));
print d.strftime('%Y-%m-%d %H:%M');")
    wl add --reminder "$wldate" --due "$(echo $wldate | cut -d' ' -f1)" "${@[@]:3}"
}
function wlh() {
    wldh 0 $1 "${@[@]:2}"
}
function wld() {
    wldh $1 0 "${@[@]:2}"
}

# TheFuck
alias fuck='TF_CMD=$(TF_ALIAS=fuck PYTHONIOENCODING=utf-8 TF_SHELL_ALIASES=$(alias) thefuck $(fc -ln -1 | tail -n 1)) && eval $TF_CMD && print -s $TF_CMD'
# VirtualEnv
if type virtualenvwrapper.sh &> /dev/null; then
    export VIRTUAL_ENV_DISABLE_PROMPT=1
    source "$(which virtualenvwrapper.sh)"
fi

# AWS aliases
alias aws-get-p2='export instanceId=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped,Name=instance-type,Values=p2.xlarge" --query "Reservations[0].Instances[0].InstanceId" | tr -d \"` && echo $instanceId'
alias aws-get-t2='export instanceId=`aws ec2 describe-instances --filters "Name=instance-state-name,Values=stopped,Name=instance-type,Values=t2.micro" --query "Reservations[0].Instances[0].InstanceId" | tr -d \"` && echo $instanceId'
alias aws-start='aws ec2 start-instances --instance-ids $instanceId && aws ec2 wait instance-running --instance-ids $instanceId && export instanceIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$instanceId" --query "Reservations[0].Instances[0].PublicIpAddress" | tr -d \"` && echo $instanceIp'
alias aws-ip='export instanceIp=`aws ec2 describe-instances --filters "Name=instance-id,Values=$instanceId" --query "Reservations[0].Instances[0].PublicIpAddress" | tr -d \"` && echo $instanceIp'
alias aws-ssh='ssh -i ~/.ssh/aws-key.pem ubuntu@$instanceIp'
alias aws-stop='aws ec2 stop-instances --instance-ids $instanceId'
alias aws-status='aws ec2 describe-instance-status --include-all-instances'

# moo
if type fortune &> /dev/null && type cowsay &> /dev/null; then
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
        fortune fortunes | cowsay $COWSTYLE
    fi
fi

# NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# kubectl autocompletion
alias kb=kubectl
source <(kubectl completion zsh)

export GPG_TTY=$(tty)

source $HOME/.config/broot/launcher/bash/br

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

true
