#!/usr/bin/env bash

# helm-repo-browser - A script to browse Helm repositories and charts interactively.
# Dependencies: helm, fzf, gum, bat

set -euo pipefail

# Colors and styling
GUM_CONFIRM_STYLE="--selected.background 2 --unselected.background 0"

function show_help() {
    echo "Usage: $(basename "$0")"
    echo "An interactive Helm repository browser."
}

function select_repo() {
    local repo
    repo=$(@helm@ repo list | @tail@ -n +2 | @awk@ '{print $1}' | @fzf@ --height 40% --layout=reverse --border --header "Select a Repository")
    echo "$repo"
}

function select_chart() {
    local repo=$1
    local chart
    chart=$(@helm@ search repo "$repo/" | @tail@ -n +2 | @fzf@ --height 40% --layout=reverse --border --header "Select a Chart in $repo" | @awk@ '{print $1}')
    echo "$chart"
}

function main_loop() {
    while true; do
        REPO=$(select_repo)

        if [[ -z "$REPO" ]]; then
            echo "No repository selected. Exiting."
            exit 0
        fi

        while true; do
            CHART=$(select_chart "$REPO")

            if [[ -z "$CHART" ]]; then
                break
            fi

            while true; do
                ACTION=$(@gum@ choose "View Default Values" "Save Default Values" "Select Different Chart" "Select Different Repository" "Exit")

                case "$ACTION" in
                    "View Default Values")
                        @gum@ spin --spinner dot --title "Fetching values for $CHART..." -- @helm@ show values "$CHART" | @bat@ -l yaml --color=always
                        ;;
                    "Save Default Values")
                        SAFE_CHART_NAME="${CHART/\//_}"
                        FILENAME=$(@gum@ input --placeholder "Enter filename (e.g., $SAFE_CHART_NAME-values.yaml)" --value "$SAFE_CHART_NAME-values.yaml")
                        if [[ -n "$FILENAME" ]]; then
                            @helm@ show values "$CHART" > "$FILENAME"
                            @gum@ style --foreground 2 "Saved to $FILENAME"
                        fi
                        ;;
                    "Select Different Chart")
                        break
                        ;;
                    "Select Different Repository")
                        CHART=""
                        break 2
                        ;;
                    "Exit")
                        exit 0
                        ;;
                esac
            done
        done
    done
}

main_loop
