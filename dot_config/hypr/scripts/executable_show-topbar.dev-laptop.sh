#!/usr/bin/bash

active_windows=$(~/.local/bin/eww active-windows)

if grep -q '^topbar_toggle:' <<<"$active_windows"; then
	exit 0
fi

~/.local/bin/eww close topbar_toggle >/dev/null 2>&1 || true

monitors_json=$(hyprctl monitors -j)
gdk_monitors_json=$(python3 ~/.config/hypr/scripts/get-gdk-monitors-json.py)

monitor_info=$(jq -r '.[] | select(.name == "eDP-1") | "\(.id)\t\(.x)\t\(.y)"' <<<"$monitors_json" | head -n1)

if [[ -z $monitor_info ]]; then
	echo "unable to resolve eDP-1 hypr monitor info for topbar window" >&2
	exit 1
fi

IFS=$'\t' read -r monitor_id monitor_x monitor_y <<<"$monitor_info"

screen_index=$(jq -r --argjson x "$monitor_x" --argjson y "$monitor_y" '
	.[] | select(.x == $x and .y == $y) | .index
' <<<"$gdk_monitors_json" | head -n1)

if [[ -z $screen_index ]]; then
	echo "unable to resolve eww screen index for eDP-1 topbar window" >&2
	exit 1
fi

~/.local/bin/eww open topbar_toggle \
	--id topbar_toggle \
	--screen "$screen_index" \
	--arg "ws_monitor=$monitor_id"

# vim: filetype=sh:
