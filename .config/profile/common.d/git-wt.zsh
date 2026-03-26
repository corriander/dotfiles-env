git-wt() {
  local target
  target="$(command git-wt "$@")" || return 1
  [ -n "$target" ] || return 0
  cd "$target" || return 1
}

git-wt-clean() {
  command git-wt clean "$@"
}

_git_wt_branch_names() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
  git -C "$root" for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null
}

_git_wt_worktree_names() {
  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || return 1
  git -C "$root" worktree list --porcelain 2>/dev/null | awk '/^branch / { sub("^refs/heads/", "", $2); print $2 }'
}

_git_wt() {
  local -a branches
  branches=(${(f)"$(_git_wt_branch_names)"})
  _describe -t branches 'branch' branches
}

_git_wt_clean() {
  local -a branches worktrees targets
  local state

  _arguments -C \
    '(-f --force)'{-f,--force}'[force removal even if the worktree has local changes or untracked files]' \
    '--delete-branch[delete the branch after removing the worktree]' \
    '1:branch or worktree:->target'

  case "$state" in
    target)
      branches=(${(f)"$(_git_wt_branch_names)"})
      worktrees=(${(f)"$(_git_wt_worktree_names)"})
      targets=(${branches[@]} ${worktrees[@]})
      targets=(${(u)targets})
      _describe -t branches 'branch or worktree' targets
      ;;
  esac
}

_git_wt_register_completions() {
  (( $+functions[compdef] )) || return 0

  compdef _git_wt git-wt
  compdef _git_wt_clean git-wt-clean

  if (( $+functions[add-zsh-hook] )); then
    add-zsh-hook -d precmd _git_wt_register_completions 2>/dev/null
  fi
}

if [[ -o interactive ]]; then
  autoload -Uz add-zsh-hook 2>/dev/null
  _git_wt_register_completions
  if ! (( $+functions[compdef] )); then
    add-zsh-hook precmd _git_wt_register_completions
  fi
fi

export GIT_WORKTREE_ROOT="${GIT_WORKTREE_ROOT:-$HOME/repos/wt}"
