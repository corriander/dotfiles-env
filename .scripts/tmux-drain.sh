#!/usr/bin/env bash
SHELLS="bash|zsh|fish|sh"
active=()

while IFS='|' read -r pane cmd; do
    if echo "$cmd" | grep -qE "^($SHELLS)$"; then
        # Shell is foreground — check last line
        last=$(tmux capture-pane -p -t "$pane" 2>/dev/null | grep -v '^\s*$' | tail -1)
        echo "$last" | grep -qE '[$%❯#>]\s*$' && continue  # looks idle
        flag="suspicious"
    else
        flag="$cmd"
    fi
    active+=("$pane|$flag")
done < <(tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}|#{pane_current_command}')

[ ${#active[@]} -eq 0 ] && echo "All clear" && exit 0

echo "=== ${#active[@]} panes need attention ==="
for i in "${!active[@]}"; do
    pane="${active[$i]%%|*}"
    flag="${active[$i]##*|}"
    title=$(tmux display-message -p -t "$pane" '#{session_name} › #{window_name} › pane #{pane_index}')
    printf "%2d. %-40s [%s]\n" "$((i+1))" "$title" "$flag"
done
