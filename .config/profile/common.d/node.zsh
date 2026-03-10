export NVM_DIR="$HOME/app/nvm"
# node install / management handled via zsh nvm plugin

_get_default_node() {
    local default_alias
    local resolved_alias
    local default_lts_name
    local default_lts_version
    local candidate

    # inspect nvm alias files directly to avoid spawning nvm during shell init
    # Prefer the configured default when it resolves to an installed version.
    default_alias=$(<$NVM_DIR/alias/default) 2>/dev/null || true
    if [[ -n "$default_alias" ]]; then
        if [[ "$default_alias" == lts/* ]]; then
            resolved_alias=$(<$NVM_DIR/alias/$default_alias) 2>/dev/null || true
        else
            resolved_alias="$default_alias"
        fi

        candidate="$NVM_DIR/versions/node/${resolved_alias}/bin/node"
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return
        fi
    fi

    default_lts_name=$(<$NVM_DIR/alias/lts/'*') 2>/dev/null || true
    default_lts_version=$(<$NVM_DIR/alias/$default_lts_name) 2>/dev/null || true
    candidate="$NVM_DIR/versions/node/${default_lts_version}/bin/node"
    if [[ -x "$candidate" ]]; then
        echo "$candidate"
        return
    fi

    echo lts
}

export MY_NODE_DEFAULT=$(_get_default_node)

add_to_path $(dirname $MY_NODE_DEFAULT) after
