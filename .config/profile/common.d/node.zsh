export NVM_DIR="$HOME/app/nvm"
# node install / management handled via zsh nvm plugin

_get_default_node() {
    # inspect nvm install dir for default node path
    default_lts_name=$(<$NVM_DIR/alias/lts/'*') 2>/dev/null
    default_lts_version=$(<$NVM_DIR/alias/$default_lts_name) 2>/dev/null
    echo $NVM_DIR/versions/node/${default_lts_version}/bin/node
}

export MY_NODE_DEFAULT=$(_get_default_node)

add_to_path $(dirname $MY_NODE_DEFAULT) after
