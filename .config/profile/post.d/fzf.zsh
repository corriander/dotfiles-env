# Load after Oh My Zsh's vi-mode plugin, which rebinds Ctrl+R.
if (( $+commands[fzf] )); then
    if _fzf_init=$(fzf --zsh 2>/dev/null); then
        eval "$_fzf_init"
    elif [[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
        if [[ -r /usr/share/doc/fzf/examples/completion.zsh ]]; then
            source /usr/share/doc/fzf/examples/completion.zsh
        fi
    elif [[ $platform == wsl && -r $HOME/.fzf.zsh ]]; then
        source "$HOME/.fzf.zsh"
    fi
    unset _fzf_init

    if (( $+widgets[fzf-history-widget] )); then
        for _fzf_map in emacs viins vicmd; do
            bindkey -M "$_fzf_map" '^R' fzf-history-widget
        done
        unset _fzf_map
    fi
fi
