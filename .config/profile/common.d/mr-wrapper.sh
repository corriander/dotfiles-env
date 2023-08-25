ms () {
    # mr wrapper that injects fzf in the pipe to select a subset of repos to operate on
    query=$1
    shift 1
    selection=$(find $HOME/.config/mr/repos-available -type f | fzf --query "$query")
    mr --trust --config $selection $*
}
