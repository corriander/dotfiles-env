# OMZ takes care of this; on WSL if we don't skip we can trigger errors on shell start
# e.g. with ephemeral docker completions
skip_global_compinit=1

case "$OSTYPE" in
  darwin*)
    platform=macos
    ;;
  linux*)
    if [[ -n "$WSL_DISTRO_NAME" || -n "$WSL_INTEROP" ]]; then
      platform=wsl
    elif [[ -r /proc/sys/kernel/osrelease ]] && grep -qi microsoft /proc/sys/kernel/osrelease; then
      platform=wsl
    elif [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
      platform=wsl
    else
      platform=linux
    fi
    ;;
  *)
    platform=unknown
    ;;
esac
