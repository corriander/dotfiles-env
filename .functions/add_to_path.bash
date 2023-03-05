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
# TODO: simplify the substring for add_to_path; no need to specify home

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
