function push-line
    set -g __fish_pushed_line (commandline)
    commandline ""
    function on-next-prompt --on-event fish_postexec
        commandline $__fish_pushed_line
        set -e __fish_pushed_line
    end
end

if status is-interactive
    set fish_greeting "$(/usr/games/fortune fortunes | /usr/games/cowsay)"
    bind -M insert \b backward-kill-word
    bind -M insert \e\[3\;5~ kill-word
    bind -M insert \cB push-line
    alias v nvim
    alias tm tmux
    alias tma "tmux attach"
    alias tmd "tmux detach"
    alias r ranger

    function x
        echo $argv
        set x $(string replace .zip "" $argv)
        7z x -o"$x" $argv
    end

    function fish_mode_prompt; end
    fish_vi_key_bindings

    set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
    set -Ux EDITOR nvim
    fzf_key_bindings
end
