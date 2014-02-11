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
add_to_path ${HOME}/.private/scripts			# sensitive scripts
add_to_path ${HOME}/.scripts/3rd-party			# 3rd party scripts
add_to_path /opt/latex/current/bin/x86_64-linux	# TexLive binaries

# ------------------------------------------------------------------ 
#
#	Non-PATH environment variables`
#
# ------------------------------------------------------------------

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

# set default editor
#
# Note: Debian/Ubuntu the 'alternatives' mechanism provides editor
# aliases. However, programs are supposed to read $EDITOR first which
# is currently unset <http://superuser.com/a/168710>
export EDITOR=/usr/bin/vim

# Special FUNCPATH for shell functions
export FUNCPATH=$HOME/.functions
