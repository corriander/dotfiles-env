# Shell-agnostic profile / config for WSL

# Ensure GPG key / pass combo is available as a backend to granted; this will
# allow passphrase prompts when caching credentials.
export GPG_TTY=$(tty)

# -----------------------------------------------------------------------------
# PATH
# -----------------------------------------------------------------------------
# Add homebrew to path
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --------------------------------------------------------------------
# Platform-specific aliases
# --------------------------------------------------------------------
NVIM_PATH=~/app/nvim.appimage

export EDITOR=$NVIM_PATH
alias nvim=$NVIM_PATH

export USERPROFILE=$HOME/win/home
export APPDATA=$USERPROFILE/appdata/Roaming
export APPDATALOCAL=$USERPROFILE/appdata/Local
