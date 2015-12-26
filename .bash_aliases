# Enable alias expansion for vim, http://stackoverflow.com/a/19819036
shopt -s expand_aliases 

# Package Management
alias apt-install='sudo apt-get install'
alias apt-remove='sudo apt-get remove'
alias apt-update='sudo apt-get update'
alias apt-search='apt-cache search'

# File / Folder Management

alias mvi='mv -iv'
alias rmi='rm -i'
alias cpi='cp -iv'

alias lsd='ls -d */'
alias tree-plain='tree -FanI .git --charset=IBM347'

# Navigation

alias cdconf='cd ${XDG_CONFIG_HOME:-$HOME/.config}'
alias cddata='cd ${XDG_DATA_HOME:-$HOME/.local/share}'
alias cdnotes='cd ~/Notebooks'
alias cdcode='cd ~/code'
alias cddocs='cd ~/Documents'
alias cddls='cd ~/Downloads'
alias cdmusic='cd /srv/multimedia/music'
alias cdaudio='cd /srv/multimedia/audio'
alias cdvideo='cd /srv/multimedia/video'
alias cdmedia='cd /srv/multimedia'

# System Admin

alias mounted='mount | column -t'

# Command replacement

case $HOSTNAME in
	$HOST_DESKTOP ) alias vim='TERM=gnome-256color vim' ;;	# Gnome, right?
	$HOST_LAPTOP ) alias vim='TERM=xterm-256color vim' ;; # ^^ doesn't exist
esac
alias dua='baobab'
alias rgrep='rgrep --color=auto'
alias vless='vim -u /usr/share/vim/vim74/macros/less.vim'
alias synonym='dict -d moby-thesaurus'
alias colout='colout -T $HOME/.config/colours'
