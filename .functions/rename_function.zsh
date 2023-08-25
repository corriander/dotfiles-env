#!/usr/bin/env zsh
#
rename_function () {
    if (( $# != 2 )); then
        echo "Usage: rename_function <oldname> <newname>" >&2
        return 1
    fi
    oldname=$1
    newname=$2
    local code=$(echo "$newname () {"; whence -f $oldname | tail -n +2)
    unset -f $oldname
    eval "$code"
}
