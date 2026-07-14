__hostname=$(scutil --get ComputerName)

add_to_path /opt/homebrew/bin
add_to_path $(brew --prefix)/opt/openjdk/bin
add_to_path $(brew --prefix)/opt/gnu-sed/libexec/gnubin
add_to_path $(brew --prefix)/opt/gnu-getopt/bin

export NVIM_PATH=/opt/homebrew/bin/nvim
export EDITOR=$NVIM_PATH


export KOBOLD_BASE_URL=http://phobos:5001

# --------------------------------------------------------------------------------
# Platform-specific aliases
# --------------------------------------------------------------------------------
function vim() {
    # alias vim to nvim
    nvim $*
}
