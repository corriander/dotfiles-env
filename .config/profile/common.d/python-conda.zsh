. $FUNCPATH/rename_function.zsh
. $FUNCPATH/fzf1.sh

CONDA_ROOT="$HOME/app/miniforge"

# If conda is not installed, skip the rest of the script
if [ ! -f "$CONDA_ROOT/bin/conda" ]; then
    return
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$($CONDA_ROOT/bin/conda 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_ROOT/etc/profile.d/conda.sh" ]; then
        . "$CONDA_ROOT/etc/profile.d/conda.sh"
    else
        export PATH="$CONDA_ROOT/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$CONDA_ROOT/etc/profile.d/mamba.sh" ]; then
    . "$CONDA_ROOT/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
#

# Introduce conda-wrapper to support activating the environment wtihin a subshell
rename_function mamba _mamba 2>/dev/null
rename_function conda _conda 2>/dev/null

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
            echo
            export CONDA_SHELL=${inner}:${environment}
            echo Entered a subshell for conda environment: $environment
            echo Use CTRL-D or exit to leave the environment
            zsh -i"
            return 0
            ;;
        *)
            $inner $@
            return 0
            ;;
    esac
}

if [[ ! -z "$CONDA_SHELL" ]]; then # && [[ "$CONDA_SHLVL" -gt 0 ]]; then
    #echo "CONDA_SHELL=${CONDA_SHELL}"
    #echo "activating"
    eval ${CONDA_SHELL/:/ activate }
fi
