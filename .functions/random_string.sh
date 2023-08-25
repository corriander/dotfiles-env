random-string () {
    charset='A-Za-z0-9'

    if [ -z "$1" ]; then
        echo >&2 "Error: insufficient arguments"
        echo "Usage: $0 [-s|--special] <length>"

    elif [ "$1" = "--special" ] || [ "$1" = "-s" ]; then 
        charset+='!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~'
        shift 1
    fi

    length=$1

    LC_ALL=C tr -dc "$charset" </dev/urandom | head -c $length ; echo
}
