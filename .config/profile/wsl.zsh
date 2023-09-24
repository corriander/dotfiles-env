# There is a bug in spaceship prompt (zsh) that leaves the ellipsis from the
# async feedback in WSL/Linux
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1321
# https://github.com/spaceship-prompt/spaceship-prompt/issues/1193#issuecomment-1432980561
SPACESHIP_ASYNC_SHOW=false

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
