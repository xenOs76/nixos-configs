#!/usr/bin/env bash
set -euo pipefail

# Dependencies provided via Nix substitution
GUM="@gum@"
FZF="@fzf@"
SYSTEMCTL="@systemctl@"
JOURNALCTL="@journalctl@"
SUDO="@sudo@"
AWK="@awk@"

# Function to list units and select one via fzf
select_unit() {
  "$SYSTEMCTL" list-units --all --plain --no-legend | "$FZF" --height 40% --layout=reverse --border --header="Select a Systemd Unit" | "$AWK" '{print $1}'
}

# Function to handle the selected action
handle_action() {
  local unit=$1
  local action=$2

  case "$action" in
  "Start")
    "$GUM" confirm "Are you sure you want to start $unit?" && "$SUDO" "$SYSTEMCTL" start "$unit"
    ;;
  "Stop")
    "$GUM" confirm "Are you sure you want to stop $unit?" && "$SUDO" "$SYSTEMCTL" stop "$unit"
    ;;
  "Restart")
    "$GUM" confirm "Are you sure you want to restart $unit?" && "$SUDO" "$SYSTEMCTL" restart "$unit"
    ;;
  "Status")
    "$SYSTEMCTL" status "$unit" | "$GUM" pager
    ;;
  "Tail Logs")
    echo "Tailing logs for $unit. Press Ctrl+C to stop."
    "$JOURNALCTL" -f -u "$unit"
    ;;
  *)
    return
    ;;
  esac
}

main() {
  while true; do
    unit=$(select_unit)

    if [[ -z "$unit" ]]; then
      echo "Exiting."
      exit 0
    fi

    while true; do
      action=$("$GUM" choose --header="Unit: $unit" "Status" "Tail Logs" "Start" "Stop" "Restart" "Back" "Exit")

      if [[ "$action" == "Exit" ]]; then
        exit 0
      elif [[ "$action" == "Back" ]]; then
        break
      fi

      handle_action "$unit" "$action"

      # For non-interactive actions, wait for user confirmation to see any errors/output
      if [[ "$action" != "Tail Logs" && "$action" != "Status" ]]; then
        echo "Press any key to return to menu..."
        read -rn 1 -s
      fi
    done
  done
}

main
