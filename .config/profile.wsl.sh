# Shell-agnostic profile / config for WSL
#
# Set up automatic keychain
# https://esc.sh/blog/ssh-agent-windows10-wsl2/
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
. $HOME/.keychain/$HOST-sh
