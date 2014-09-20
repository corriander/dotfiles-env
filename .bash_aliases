# Enable alias expansion for vim, http://stackoverflow.com/a/19819036
shopt -s expand_aliases 

# Package Management
alias apt-install='sudo apt-get install'
alias apt-remove='sudo apt-get remove'
alias apt-update='sudo apt-get update'
alias repo-add='sudo apt-add-repository'
alias repo-remove='sudo apt-add-repository --remove'

# File / Folder Management

alias mvi='mv -iv'
alias rmi='rm -i'
alias cpi='cp -iv'

alias lsd='ls -d */'
alias tree_plain='tree -FanI .git --charset=IBM347'

# Navigation

alias cd_docs='cd ~/Documents'
alias cd_dl='cd ~/Downloads'
alias cd_music='cd /mnt/multimedia/music'
alias cd_audio='cd /mnt/multimedia/audio'
alias cd_video='cd /mnt/multimedia/video'
alias cd_multimedia='cd /mnt/multimedia'
alias ..='..'
alias ...='../..'
alias ....='../../..'

# System Admin

alias mounted='mount | column -t'

# Command replacement

case $HOSTNAME in
	$HOST_DESKTOP ) alias vim='TERM=gnome-256color vim' ;;	# Gnome, right?
	$HOST_LAPTOP ) alias vim='TERM=xterm-256color vim' ;; # ^^ doesn't exist
esac
alias dua='baobab'
alias rgrep='rgrep --color=auto'
