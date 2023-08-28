. $FUNCPATH/rename_function.zsh
. $FUNCPATH/fzf1.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($HOME/app/mambaforge/bin/conda 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/app/mambaforge/etc/profile.d/conda.sh" ]; then
        . "$HOME/app/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/app/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/app/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "$HOME/app/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
#

# Introduce conda-wrapper to support activating the environment wtihin a subshell
rename_function mamba _mamba
rename_function conda _conda

mamba () {
    _conda_wrapper $@
    return $?
}

conda () {
    _conda_wrapper $@
    return $?
}

_conda_wrapper () {

    invoker=${funcstack[-1]}
    inner=_${invoker}

    find_env__fuzzy () {
        echo $($inner env list | awk '!/^#/ {print $1}' | fzf1 $1)
        return $?
    }

    find_env__exact () {
        array_contains () {
            local elem
            for elem in "${@:2}"; do
                [ "$elem" = "$1" ] && return 0
            done
            return 1
        }
        env_list=($($inner env list | awk '!/^#/ {print $1}'))
        array_contains "$1" "${env_list[@]}" && echo "$1" && return 0
    }
    
    case $1 in
        enter)
            shift
            if [ "$1" = "-e" ] || [ "$1" = "--exact" ]; then
                shift
                environment=$(find_env__exact $1)
            else
                environment=$(find_env__fuzzy $1)
            fi

            if [ $? -ne 0 ]; then
                echo >&2 "No matching environment"
                return 1
            fi

            zsh -c "
            . ~/.zshrc
            $inner activate $environment
            echo
            echo Entered a subshell loaded with conda environment: $environment
            echo Exit the subshell to leave the environment.
            zsh -i"
            return 0
            ;;
        *)
            $inner $@
            return 0
            ;;
    esac
}
