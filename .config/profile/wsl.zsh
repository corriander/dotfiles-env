# There is a bug in spaceship prompt (zsh) that leaves the ellipsis from the
# async feedback in WSL/Linux
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1321
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193#issuecomment-1432980561
SPACESHIP_ASYNC_SHOW=false

# Docker Desktop on WSL can leave a dangling _docker completion symlink when
# the Desktop VM is down. Mirror vendor completions locally and drop broken
# links so compinit still succeeds.
_zsh_vendor_completions=/usr/share/zsh/vendor-completions
_zsh_vendor_cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/vendor-completions

if [[ -L $_zsh_vendor_completions/_docker && ! -e $_zsh_vendor_completions/_docker ]]; then
    mkdir -p "$_zsh_vendor_cache"
    for _completion in $_zsh_vendor_completions/*(N); do
        [[ -L $_completion && ! -e $_completion ]] && continue
        ln -sfn "$_completion" "$_zsh_vendor_cache/${_completion:t}"
    done
    fpath=($_zsh_vendor_cache ${fpath:#$_zsh_vendor_completions})
fi

unset _completion _zsh_vendor_cache _zsh_vendor_completions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

__configure_aws_codeartifact () {
    # requires poetry-source-env plugin
    #domain_owner=$(aws sts get-caller-identity --query "Account" --output text)
    domain_owner=$(aws configure get sso_account_id)
    region=$(aws configure get region)
    domain=$(aws codeartifact list-domains --query "domains[0].name" --output text)
    repo=$(aws codeartifact list-repositories --query 'repositories[?contains(name, ''`-`'') == `false`].name' --output text)
    export POETRY_REPOSITORIES_CODEARTIFACT_URL=$(
        aws codeartifact get-repository-endpoint \
            --domain-owner ${domain_owner} \
            --region ${region} \
            --domain ${domain} \
            --repository ${repo} \
            --format pypi \
            --query repositoryEndpoint \
            --output text
    )simple/
    export POETRY_REPOSITORIES_CODEARTIFACT_PRIORITY=supplemental
}

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
        __configure_aws_codeartifact
    else
        $cmd "$@"
    fi

    return 0
}
