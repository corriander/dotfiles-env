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

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi

# set PATH so it includes user's scripts (.scripts) folder if exists
if [ -d "$HOME/.scripts" ] ; then
    PATH="$HOME/.scripts:$PATH"
fi

# set LaTeX paths for TeXLive installation
path="/opt/latex/current/texmf/doc/info"
if [ -d "$path" ] ; then
    INFOPATH="$path:$INFOPATH"
fi

path="/opt/latex/current/texmf/doc/man"
if [ -d "$path" ] ; then
    MANPATH="$path:$MANPATH"
fi

path="/opt/latex/current/bin/x86_64-linux"
if [ -d "$path" ] ; then
    PATH="$path:$PATH"
fi
export LANGUAGE="en_GB:en"
export LC_MESSAGES="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"


# set JAVA_HOME

export JAVA_HOME=/usr/lib/jvm/default-java
