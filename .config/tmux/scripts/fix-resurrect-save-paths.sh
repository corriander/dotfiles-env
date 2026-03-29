#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
	exit 1
fi

state_file="$1"

if [[ ! -f "$state_file" ]]; then
	exit 0
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

while IFS= read -r line; do
	if [[ "$line" != pane$'\t'* ]]; then
		printf '%s\n' "$line" >> "$tmp_file"
		continue
	fi

IFS=$'\t' read -r line_type session_name window_number window_active window_flags pane_index pane_title dir pane_active pane_command pane_full_command <<< "$line"

	target_dir="${pane_title#:}"
	saved_dir="${dir#:}"

	case "$pane_command" in
		bash|claude|codex|fish|sh|zsh)
			if [[ "$saved_dir" == "$HOME" && "$target_dir" == /* && -d "$target_dir" ]]; then
				dir=":$target_dir"
			fi
			;;
	esac

	printf '%s\n' "$(printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s' "$line_type" "$session_name" "$window_number" "$window_active" "$window_flags" "$pane_index" "$pane_title" "$dir" "$pane_active" "$pane_command" "$pane_full_command")" >> "$tmp_file"
done < "$state_file"

mv "$tmp_file" "$state_file"
