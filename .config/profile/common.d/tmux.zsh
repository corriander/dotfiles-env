_tmux_check_vcsh_env() {
  local -a env_vars
  local env_var
  local has_error=0

  env_vars=(
    GIT_DIR
    GIT_INDEX_FILE
    GIT_OBJECT_DIRECTORY
    GIT_WORK_TREE
    VCSH_COMMAND
    VCSH_DIRECTORY
    VCSH_REPO_NAME
  )

  for env_var in "${env_vars[@]}"; do
    if [[ -n "${(P)env_var:-}" ]]; then
      print -u2 "tmux: environment variable '$env_var' is set."
      has_error=1
    fi
  done

  if (( has_error )); then
    print -u2 "tmux: The variables above would lead to very interesting effects."
    print -u2 "    Unfortunately, most of those effects result in data loss so we stop here."
    return 1
  fi
}

tmux() {
  _tmux_check_vcsh_env || return 1
  command tmux "$@"
}
