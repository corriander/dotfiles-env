# adds some further stratification to platform detection to allow better differentiation
case "$platform" in
  wsl)
    export PLATFORM_OS=linux
    export PLATFORM_KIND=wsl
    ;;
  linux)
    export PLATFORM_OS=linux
    export PLATFORM_KIND=linux
    ;;
  macos)
    export PLATFORM_OS=macos
    export PLATFORM_KIND=macos
    ;;
esac
