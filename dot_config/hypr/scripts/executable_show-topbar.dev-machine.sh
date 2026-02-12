#!/usr/bin/bash

active_windows=$(~/.local/bin/eww active-windows)

if grep -q '^tbt_primary:' <<<"$active_windows" \
	&& grep -q '^tbt_second:' <<<"$active_windows" \
	&& grep -q '^tbt_third:' <<<"$active_windows"; then
	exit 0
fi

~/.local/bin/eww close tbt_primary >/dev/null 2>&1 || true
~/.local/bin/eww close tbt_second >/dev/null 2>&1 || true
~/.local/bin/eww close tbt_third >/dev/null 2>&1 || true

monitors_json=$(hyprctl monitors -j)
gdk_monitors_json=$(python3 ~/.config/hypr/scripts/get-gdk-monitors-json.py)

get_hypr_monitor_info() {
	local monitor_name="$1"

	jq -r --arg monitor_name "$monitor_name" '
		.[] | select(.name == $monitor_name) | "\(.id)\t\(.x)\t\(.y)"
	' <<<"$monitors_json" | head -n1
}

get_eww_screen_index_by_xy() {
	local x="$1"
	local y="$2"

	jq -r --argjson x "$x" --argjson y "$y" '
		.[] | select(.x == $x and .y == $y) | .index
	' <<<"$gdk_monitors_json" | head -n1
}

primary_info=$(get_hypr_monitor_info "DP-1")
second_info=$(get_hypr_monitor_info "HDMI-A-1")
third_info=$(get_hypr_monitor_info "HDMI-A-2")

if [[ -z $primary_info || -z $second_info || -z $third_info ]]; then
	echo "unable to resolve hypr monitor info for topbar windows" >&2
	exit 1
fi

IFS=$'\t' read -r primary_monitor_id primary_x primary_y <<<"$primary_info"
IFS=$'\t' read -r second_monitor_id second_x second_y <<<"$second_info"
IFS=$'\t' read -r third_monitor_id third_x third_y <<<"$third_info"

primary_screen_index=$(get_eww_screen_index_by_xy "$primary_x" "$primary_y")
second_screen_index=$(get_eww_screen_index_by_xy "$second_x" "$second_y")
third_screen_index=$(get_eww_screen_index_by_xy "$third_x" "$third_y")

if [[ -z $primary_screen_index || -z $second_screen_index || -z $third_screen_index ]]; then
	echo "unable to resolve eww screen indices for topbar windows" >&2
	exit 1
fi

~/.local/bin/eww open topbar_toggle \
	--id tbt_primary \
	--screen "$primary_screen_index" \
	--arg "ws_monitor=$primary_monitor_id"

~/.local/bin/eww open topbar_toggle \
	--id tbt_second \
	--screen "$second_screen_index" \
	--arg "ws_monitor=$second_monitor_id"

~/.local/bin/eww open topbar_toggle \
	--id tbt_third \
	--screen "$third_screen_index" \
	--arg "ws_monitor=$third_monitor_id"

# vim: filetype=sh:
