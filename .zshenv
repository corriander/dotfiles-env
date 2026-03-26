# OMZ takes care of this; on WSL if we don't skip we can trigger errors on shell start
# e.g. with ephemeral docker completions
skip_global_compinit=1

case "$OSTYPE" in
  darwin*)
    export PLATFORM_OS=macos
    export PLATFORM_KIND=macos
    ;;
  linux*)
    export PLATFORM_OS=linux
    if [[ -n "$WSL_DISTRO_NAME" || -n "$WSL_INTEROP" ]]; then
      # cheap
      export PLATFORM_KIND=wsl
    elif [[ -r /proc/sys/kernel/osrelease ]] && grep -qi microsoft /proc/sys/kernel/osrelease; then
      # less cheap
      export PLATFORM_KIND=wsl
    elif [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
      # even less cheap
      export PLATFORM_KIND=wsl
    else
      export PLATFORM_KIND=linux
    fi
    ;;
  *)
    export PLATFORM_OS=unknown
    export PLATFORM_KIND=unknown
    ;;
esac
