. $FUNCPATH/add_to_path.bash
. $FUNCPATH/rename_function.zsh

export PYENV_ROOT=$HOME/app/pyenv

pyenv-enable () {
    command -v pyenv >/dev/null || add_to_path $PYENV_ROOT/bin
    eval "$(pyenv init -)"
}

pyenv-disable () {
    unset PYENV_SHELL
    unfunction pyenv
    PATH=$(echo $PATH | tr ':' '\n' | egrep -v pyenv | paste -sd:)
}
