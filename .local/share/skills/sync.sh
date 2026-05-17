#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SKILLS=(
  handoff
  recall
)

TARGET_DIRS=(
  "$HOME/.claude/skills"
  "$HOME/.codex/skills"
)

status=0

for skill in "${SKILLS[@]}"; do
  source_dir="$ROOT_DIR/$skill"

  if [[ ! -d "$source_dir" ]]; then
    printf 'missing source skill: %s\n' "$source_dir" >&2
    status=1
  fi
done

for target_dir in "${TARGET_DIRS[@]}"; do
  if [[ ! -d "$target_dir" ]]; then
    printf 'missing consumer skills dir: %s\n' "$target_dir" >&2
    status=1
    continue
  fi

  for skill in "${SKILLS[@]}"; do
    source_dir="$ROOT_DIR/$skill"
    target_path="$target_dir/$skill"

    if [[ ! -d "$source_dir" ]]; then
      continue
    fi

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

exit "$status"
