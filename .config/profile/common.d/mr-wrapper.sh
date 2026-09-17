ms () {
    # mr wrapper that injects fzf in the pipe to select a subset of repos to operate on
    query=$1
    shift 1
    selection=$(find $HOME/.config/mr/repos-available -type f | fzf --query "$query")
    mr --trust --config $selection $*
}

# Soft wrapper adding the snippet management commands and mr's missing
# descent into symlinked roots. Everything else falls through untouched.
#
# Deliberately declared *after* ms(). zsh expands an already-defined alias
# into a function body as it parses the definition, and common.sh sources
# ../aliases well before this directory - so declaring it there would have
# silently routed ms() through the wrapper too, adding a symlinked-root pass
# to a call that is meant to be scoped to one selected config. Verified in
# both zsh and bash: with this ordering ms() still reaches mr itself.
alias mr='WRAPPED_CMD=mr $HOME/.scripts/mr-wrapper'
