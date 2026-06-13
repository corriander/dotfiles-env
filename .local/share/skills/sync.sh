#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# WSL consumers: symlink (same filesystem, edits propagate live).
LINK_TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

# Windows consumers: copy. NTFS over /mnt can't take the unix symlinks the
# Windows apps follow, so we mirror one-way (WSL -> Windows). Re-run after
# editing a skill in WSL to push the change. The Windows .claude/skills dir is
# shared by both Claude Desktop and the Claude Code CLI. Override WIN_USER if
# the Windows account name differs from the default.
WIN_USER="${WIN_USER:-alexj}"
WIN_BASE="/mnt/c/Users/$WIN_USER"
COPY_TARGETS=(
  "$WIN_BASE/.claude/skills"
  "$WIN_BASE/.codex/skills"
)

status=0
skills=()

# Discover skills: top-level dirs only, excluding hidden dirs like .claude
# (tracked settings, not a skill) so only real skills are distributed.
while IFS= read -r skill_dir; do
  skills+=("$(basename "$skill_dir")")
done < <(find "$ROOT_DIR" -mindepth 1 -maxdepth 1 -type d -not -name '.*' | sort)

# --- WSL: symlink into consumer skill dirs ---
for target_dir in "${LINK_TARGETS[@]}"; do
  if [[ ! -d "$target_dir" ]]; then
    printf 'missing consumer skills dir: %s\n' "$target_dir" >&2
    status=1
    continue
  fi

  for skill in "${skills[@]}"; do
    source_dir="$ROOT_DIR/$skill"
    target_path="$target_dir/$skill"

    if [[ -L "$target_path" ]]; then
      current_target="$(readlink "$target_path")"
      if [[ "$current_target" == "$source_dir" ]]; then
        printf 'ok: %s -> %s\n' "$target_path" "$current_target"
      else
        printf 'conflict: %s points to %s, expected %s\n' "$target_path" "$current_target" "$source_dir" >&2
        status=1
      fi
      continue
    fi

    if [[ -e "$target_path" ]]; then
      printf 'conflict: %s exists and is not a managed symlink\n' "$target_path" >&2
      status=1
      continue
    fi

    ln -s "$source_dir" "$target_path"
    printf 'linked: %s -> %s\n' "$target_path" "$source_dir"
  done
done

# --- Windows: copy into consumer skill dirs (skip cleanly if not mounted) ---
for target_dir in "${COPY_TARGETS[@]}"; do
  parent_dir="$(dirname "$target_dir")"
  if [[ ! -d "$parent_dir" ]]; then
    printf 'skip (no Windows consumer mounted): %s\n' "$parent_dir"
    continue
  fi

  mkdir -p "$target_dir"

  for skill in "${skills[@]}"; do
    source_dir="$ROOT_DIR/$skill"
    target_path="$target_dir/$skill"

    if command -v rsync >/dev/null 2>&1; then
      rsync -a --delete "$source_dir/" "$target_path/"
    else
      rm -rf "$target_path"
      cp -r "$source_dir" "$target_path"
    fi
    printf 'copied: %s -> %s\n' "$target_path" "$source_dir"
  done
done

exit "$status"
