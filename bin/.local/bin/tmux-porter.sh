#!/usr/bin/env bash

# 1) Gather all listening PIDs → ports
declare -A pid_ports
while IFS= read -r line; do
  pid="${line%%:*}"
  addr="${line#*:}"
  port="${addr##*:}"
  pid_ports["$pid"]+="$port "
done < <(
  lsof -iTCP -sTCP:LISTEN -P -n \
    | awk 'NR>1 {print $2 ":" $9}' \
    | sort -u
)

# If no listening ports at all, bail early
if [[ ${#pid_ports[@]} -eq 0 ]]; then
  echo "No listening ports found by lsof."
  exit 1
fi

# 2) Map each tmux pane’s TTY → session name(s)
declare -A tty_sessions
while IFS= read -r pane; do
  session="${pane%% *}"
  tty="${pane#* }"
  tty_sessions["$tty"]+="$session "
done < <(tmux list-panes -a -F "#{session_name} #{pane_tty}")

# 3) For each listening PID, look up its TTY via ps, match to sessions
declare -A session_ports
for pid in "${!pid_ports[@]}"; do
  tty=$(ps -p "$pid" -o tty= | xargs)
  [[ -z "$tty" || "$tty" == "?" ]] && continue
  dev_tty="/dev/$tty"
  for session in ${tty_sessions[$dev_tty]}; do
    session_ports["$session"]+="${pid_ports[$pid]}"
  done
done

# 4) No matches?
if [[ ${#session_ports[@]} -eq 0 ]]; then
  echo "No tmux sessions found with listening ports."
  exit 1
fi

# 5) Build fzf menu
mapfile -t fzf_input < <(
  for session in "${!session_ports[@]}"; do
    ports=$(echo "${session_ports[$session]}" | xargs -n1 | sort -u | xargs)
    echo "$session | ports: $ports"
  done
)

# 6) Let user pick and switch
selected=$(printf '%s\n' "${fzf_input[@]}" \
           | fzf --prompt="Select tmux session: ")
if [[ -n "$selected" ]]; then
  target="${selected%% *}"
  tmux switch-client -t "$target"
fi
