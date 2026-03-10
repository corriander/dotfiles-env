git-wt() {
  # Create or switch to a git worktree for the specified branch
  #
  # Supports distinct worktree directories for different branches, with parallel
  # work supported
  #
  # Usage:
  #   git-wt <branch>
  #
  # If the branch exists, it will be checked out in a new worktree.
  # If it doesn't exist, it will be created and checked out.
  local branch="$1"
  local base="${GIT_WT_BASE:-../wt}"

  if [ -z "$branch" ]; then
    echo "usage: git-wt <branch>"
    return 1
  fi

  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "not inside a git repository"
    return 1
  }

  local name="${branch//\//-}"
  local wt_dir="$base/$name"

  mkdir -p "$base"

  if [ -e "$wt_dir/.git" ]; then
    cd "$wt_dir" || return 1
    return 0
  fi

  if git -C "$root" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$root" worktree add "$wt_dir" "$branch" || return 1
  else
    git -C "$root" worktree add "$wt_dir" -b "$branch" || return 1
  fi

  cd "$wt_dir" || return 1
}


git-wt-clean() {
  # Delete git worktree and, optionally, the branch
  local branch=""
  local delete_branch=0
  local force=0
  local base="${GIT_WT_BASE:-../wt}"

  while [ "$#" -gt 0 ]; do
    case "$1" in
      -f|--force)
        force=1
        ;;
      --delete-branch)
        delete_branch=1
        ;;
      -h|--help)
        echo "usage: git-wt-clean [-f|--force] <branch> [--delete-branch]"
        return 0
        ;;
      -*)
        echo "unknown option: $1"
        echo "usage: git-wt-clean [-f|--force] <branch> [--delete-branch]"
        return 1
        ;;
      *)
        if [ -n "$branch" ]; then
          echo "usage: git-wt-clean [-f|--force] <branch> [--delete-branch]"
          return 1
        fi
        branch="$1"
        ;;
    esac
    shift
  done

  if [ -z "$branch" ]; then
    echo "usage: git-wt-clean [-f|--force] <branch> [--delete-branch]"
    return 1
  fi

  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "not inside a git repository"
    return 1
  }

  local name="${branch//\//-}"
  local wt_dir="$base/$name"

  # Remove worktree if it exists
  if [ -d "$wt_dir" ]; then
    # Refuse to remove when currently inside the target worktree (or a subdir).
    local cwd_abs
    local wt_abs
    cwd_abs="$(pwd -P)"
    wt_abs="$(cd "$wt_dir" 2>/dev/null && pwd -P)" || return 1
    if [ "$cwd_abs" = "$wt_abs" ] || [[ "$cwd_abs" == "$wt_abs/"* ]]; then
      echo "currently inside target worktree: $wt_dir"
      echo "cd elsewhere and rerun"
      return 1
    fi

    if [ "$force" -eq 1 ]; then
      git -C "$root" worktree remove --force "$wt_dir" || return 1
    else
      git -C "$root" worktree remove "$wt_dir" || return 1
    fi
    git -C "$root" worktree prune
  else
    echo "worktree not found: $wt_dir"
  fi

  # Optional branch delete (safe delete only)
  if [ "$delete_branch" -eq 1 ]; then
    git -C "$root" branch -d "$branch" || return 1
  fi
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

export GIT_WT_BASE="$HOME/repos/worktrees"
