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
  local branch="$1"
  local delete_flag="$2"   # optional: --delete-branch
  local base="${GIT_WT_BASE:-../wt}"

  if [ -z "$branch" ]; then
    echo "usage: git-wt-clean <branch> [--delete-branch]"
    return 1
  fi

  local root
  root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "not inside a git repository"
    return 1
  }

  local name="${branch//\//-}"
  local wt_dir="$base/$name"

  # Refuse to remove current directory
  local cwd
  cwd="$(pwd)"
  if [ "$cwd" = "$wt_dir" ]; then
    echo "currently inside target worktree: $wt_dir"
    echo "cd elsewhere and rerun"
    return 1
  fi

  # Remove worktree if it exists
  if [ -d "$wt_dir" ]; then
    git -C "$root" worktree remove "$wt_dir" || return 1
    git -C "$root" worktree prune
  else
    echo "worktree wt_dir not found: $path"
  fi

  # Optional branch delete (safe delete only)
  if [ "$delete_flag" = "--delete-branch" ]; then
    git -C "$root" branch -d "$branch" || return 1
  fi
}

export GIT_WT_BASE="$HOME/repos/worktrees"
