# Source Prezto
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Run Fasd
unalias d
alias d="dirs -v"
alias fd="fasd -d"
alias z='fasd_cd -d'
alias zz='fasd_cd -d -i'

# a and f
function _glob_expand() {
    res=()
    for param in $@; do
        res+=("$(zsh -c "print -l $param")")
    done
    if [[ $res != "" ]]; then
        print -l $res
    fi
}
function _f() {
    if [[ $# -eq 1 ]]; then
        fdir='.'
    elif [[ $# -gt 1 ]]; then
        fdir=$(_glob_expand ${@:2})
    else
        return 1
    fi
    res=$(echo $fdir | xargs -d '\n' find -L | ag "$1")
    if [[ -z $res ]]; then
        return 1
    fi
    echo $res
}
alias f='noglob _f'
function _cdf() {
    found=$(f $@)
    if [[ $? -eq 0 ]]; then
        echo $found | while read res; do
            if [[ -d $res ]]; then
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
alias ff='fasd -f'
alias fv='fasd -f -t -e vim -b viminfo'
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
        printf "%s\0" $onlyfiles | xargs -0 sh -c 'vim "$@" < /dev/tty' vim
    else
        return $?
    fi
}
alias vf='noglob _vf'
function _a() {
    let cnt=1
    lastparam=""
    for param in $@; do
        if [[ $param[1] != "-" || lastparam == "--" ]]; then break; fi
        lastparam=$param
        let cnt=cnt+1
    done
    xargs -a <(_glob_expand ${@:$cnt+1}) -d '\n' ag ${@:1:$cnt}
}
alias a='noglob _a --nonumbers --hidden'
function _va() {
    lastparam=""
    for param in $@; do
        if [[ $param[1] != "-" || lastparam == "--" ]]; then break; fi
        lastparam=$param
    done
    vimexec="vim '+silent!/$param' \"\$@\" < /dev/tty"
    found=$(a --print0 -l $@)
    if [[ $? -eq 0 ]]; then
        echo -n $found | xargs -0 sh -c $vimexec vim
        return 0
    else
        return $?
    fi
}
alias va='noglob _va'

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
source "$HOME/bin/fzf/shell/key-bindings.zsh"

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
alias v="vim"
alias vl="vim -u ~/.vimlessrc -"
alias gv="gvim"
alias sv="sudo vim"
alias new="i3-sensible-terminal ."

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
alias gbin="git bisect bad"
alias gbiy="git bisect good"
alias gbl="git blame -s"
alias gc="git commit --signoff"
alias gca="git commit --amend --signoff"
alias gcaa="git commit --amend --no-edit --signoff"
alias gch="git checkout"
alias gcherry="git cherry-pick"
function gchpr(){git fetch $1 refs/pull/$2/head:pr/$2 && git checkout pr/$2;}
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
alias glast="git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --stat -1"
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
    git commit --signoff -m "$*"
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias inst="sudo apt-get install"
alias rmf="rm -rf"
alias ag="ag --nonumbers"
alias r="ranger"
function mkcd() {
    command mkdir -p $1 && cd $1
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
        fortune | cowsay $COWSTYLE
    fi
fi

# NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
