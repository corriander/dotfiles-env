_patch_omz_nvm_lazy_wrappers() {
    zstyle -t ':omz:plugins:nvm' lazy || return 0

    local -a nvm_lazy_cmd
    zstyle -a ':omz:plugins:nvm' lazy-cmd nvm_lazy_cmd 2>/dev/null
    nvm_lazy_cmd=(_omz_nvm_load nvm node npm npx pnpm pnpx yarn corepack $nvm_lazy_cmd)
    nvm_lazy_cmd=(${(u)nvm_lazy_cmd})

    eval "
        function $nvm_lazy_cmd {
            for func in $nvm_lazy_cmd; do
                if (( \$+functions[\$func] )); then
                    unfunction \$func
                fi
            done
            [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
            (( \$+functions[_omz_nvm_setup_completion] )) && _omz_nvm_setup_completion
            (( \$+functions[_omz_nvm_setup_autoload] )) && _omz_nvm_setup_autoload
            if [[ \"\$0\" != _omz_nvm_load ]]; then
                \"\$0\" \"\$@\"
            fi
        }
    "
}

_patch_omz_nvm_lazy_wrappers
unfunction _patch_omz_nvm_lazy_wrappers
