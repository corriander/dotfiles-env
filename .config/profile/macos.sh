add_to_path /opt/homebrew/bin
add_to_path $(brew --prefix)/opt/openjdk/bin
add_to_path $(brew --prefix)/opt/gnu-sed/libexec/gnubin
add_to_path $(brew --prefix)/opt/gnu-getopt/bin
export EDITOR=/opt/homebrew/bin/nvim

# aliases
function vim () {
	nvim $*
}
