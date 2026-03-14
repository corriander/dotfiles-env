#!/usr/bin/env bash

set -euo pipefail

names=(
  black red green yellow blue magenta cyan white
  brightblack brightred brightgreen brightyellow
  brightblue brightmagenta brightcyan brightwhite
)

sample() {
  local idx="$1"
  local name="$2"
  local fg=15

  if (( idx == 7 || idx >= 8 )); then
    fg=0
  fi

  printf '\033[48;5;%sm\033[38;5;%sm %-14s colour%-3s \033[0m\n' "$idx" "$fg" "$name" "$idx"
}

printf 'System colors used by tmux named palette:\n\n'

for i in "${!names[@]}"; do
  sample "$i" "${names[$i]}"
done
