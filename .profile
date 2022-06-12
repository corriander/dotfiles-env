# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# ------------------------------------------------------------------
# ------------------------------------------------------------------
#
#                        USER MODIFICATIONS
#
# ------------------------------------------------------------------
# ------------------------------------------------------------------
#
#	PATH settings
#
# ------------------------------------------------------------------

# First, a function to simplify the repetitive adding-to-PATH
# Sources:
#	http://superuser.com/a/39995
#	http://superuser.com/a/462982
#	http://stackoverflow.com/a/8811800/2921610
#
# TODO: I'm currently adding to the start of PATH to allow overriding
# executables. There's a security consideration here in that malicious
# code could override common utilities *but* surely there's multiple
# vectors for this, so I'm currently uncertain whether it's worth the
# inconvenience.
# -- <http://unix.stackexchange.com/a/26048>
#
# TODO: http://pastebin.com/xS9sgQsX contains some nice ideas

add_to_path () {
    # Checks arg is an extant directory and isn't already in PATH
    # Future me: see 'shell parameter expansion' in man for ${x:+$y}
    string=:$PATH:
    substring=:$1:
    if [ -d "$1" ] && [ "${string#*$substring}" = "$string" ]; then
        if [ "$2" = "after" ] ; then
            PATH="${PATH:+"$PATH:"}$1"
        else
            PATH="$1${PATH:+":$PATH"}"
        fi
    fi
}

add_to_path ${HOME}/.bin						# my bin
add_to_path ${HOME}/.local/bin					# bin (inc. overrides)
add_to_path ${HOME}/.scripts					# scripts
add_to_path ${HOME}/.scripts/git				# git-related scripts
add_to_path ${HOME}/.private/scripts			# sensitive scripts
add_to_path ${HOME}/.scripts/3rd-party			# 3rd party scripts
add_to_path /opt/latex/current/bin/x86_64-linux	# TexLive binaries
add_to_path /opt/alex/miniconda3/bin			# Miniconda install.

# ------------------------------------------------------------------
#
#	Non-PATH environment variables`
#
# ------------------------------------------------------------------
#
# XDG Overrides
# -------------
#
# XDG paths are used later (with fallbacks) so they need to be set here.
#
# export XDG_CONFIG_HOME=$HOME/.config
# export XDG_CACHE_HOME=$HOME/.cache
# export XDG_DATA_HOME=$HOME/.local/share
# export XDG_RUNTIME_DIR=$HOME/.cache/runtime
# NOTE: rules for this runtime directory are somewhat complicated:
#  - Must be user specific (0700)
#  - Lifetime is bound to user log in, must exist from the first login and until
#	 the user is fully logged out (irrespective of interim logins).
#  - The directory contents must not survive reboot or a full login/logout
#    cycle, but the directory itself should always be available otherwise.
#  - Local file system, not shared. Must support full OS features.
#  - Files may be cleaned up if access > 6 hrs or sticky bit unset.
#  - No large files (may be in RAM!), fallback location should be equivalent.
#  	 Applications should use this directory for comms and synchronisation.

# set LaTeX paths for TeXLive installation
path="/opt/latex/current/texmf/doc/info"
if [ -d "$path" ] ; then
    INFOPATH="$path:$INFOPATH"
fi

path="/opt/latex/current/texmf/doc/man"
if [ -d "$path" ] ; then
    MANPATH="$path:$MANPATH"
fi

# Define which languages `gettext` should use / fall back on
# http://www.gnu.org/software/gettext/manual/gettext.html#The-LANGUAGE-variable
export LANGUAGE="en_GB:en"

# Set locale
# https://help.ubuntu.com/community/EnvironmentVariables#Locale_setting_variables
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"

# set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/default-java

# set R user libraries to XDG_DATA_HOME (`current` is symlink to current ver.)
export R_LIBS_USER=${XDG_DATA_HOME:-$HOME/.local/share/R/current/}

# Configure text editor(s)
#
# Note: Debian/Ubuntu the 'alternatives' mechanism provides editor
# aliases. However, programs are supposed to read $EDITOR first which
# is currently unset <http://superuser.com/a/168710>
export EDITOR=/usr/bin/vim
# See https://tlvince.com/vim-respect-xdg; required for vimrc.
export VIMINIT='let $MYVIMRC = "'${XDF_CONFIG_HOME:-~/.config}'/vim/vimrc" | source $MYVIMRC'

# Special FUNCPATH for shell functions; some functions have missing dependencies;
# shush them if so.
export FUNCPATH=$HOME/.functions
. $FUNCPATH/default 2>/dev/null

# Configure python environment
#
# Override the location of jupyter config.
export JUPYTER_CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}/jupyter
# Set the default location of Python projects.
export CONDAWRAPPER_PROJECTS=~/repos
export CONDARC=${XDG_CONFIG_HOME:-$HOME/.config}/conda/condarc

# ------------------------------------------------------------------------------
#
# WSL-specific configuration
#
# ------------------------------------------------------------------------------
# Source the SSH environment file to attach to an already-running SSH agent.
# https://github.com/bahamas10/dotfiles/commit/fd7047243293674ed38f69ce5653104373ac727b
if uname -a | grep -q '^Linux.*Microsoft'
then
	# This may not exist in all environments so just be quiet if missing.
	. ~/.ssh/environment >&2 >/dev/null || ~/.local/bin/start-ssh-agent >&2 >/dev/null
fi
