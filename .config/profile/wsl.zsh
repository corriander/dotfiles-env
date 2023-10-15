# There is a bug in spaceship prompt (zsh) that leaves the ellipsis from the
# async feedback in WSL/Linux
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1321
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193#issuecomment-1432980561
SPACESHIP_ASYNC_SHOW=false

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

assume () {
    cmd=/usr/local/bin/assume
    if [[ "$1" == "--unset" ]]; then
        $cmd "$@" && unset AWS_PROFILE || return $?
        return 0
    fi

    aws_profiles=($(aws configure list-profiles))
    arg1_is_profile=false
    for item in "${aws_profiles[@]}"; do
        [[ "$item" == "$1" ]] && arg1_is_profile=true && break
    done

    # if arg1_is_profile; hijack the command and do our own thing on WSL because it's broken
    if $arg1_is_profile; then
        echo >&2 "$(tput setaf 3)Overriding granted/assume (is it still broken on WSL?)$(tput op)"
        echo ""
        export AWS_PROFILE=$1
        aws sso login
    else
        $cmd "$@"
    fi

    return 0
}
