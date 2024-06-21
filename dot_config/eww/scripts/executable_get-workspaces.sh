#!/usr/bin/env bash

MONITOR="$1"

spaces() {
	WORKSPACE_WINDOWS="$(hyprctl workspaces -j | jq --arg monitor "$MONITOR" 'map(select(.monitor == $monitor)) | map({key: .id | tostring, value: .windows}) | from_entries')"
	seq 1 10 | jq --argjson windows "${WORKSPACE_WINDOWS}" --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'
}

spaces
# socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
# 	spaces
# done
#
# workspaces_rules=$(hyprctl workspacerules -j | jq -r ".[] | {name: .workspaceString, monitor: .monitor, empty: true}")
# workspaces_open=$(hyprctl workspaces -j | jq -r ".[] | {name: .name, monitor: .monitor, empty: false}")
#
# ws_array="$(echo "$workspaces_rules$workspaces_open" | jq -r '[inputs]')"
#
# echo "$ws_array" | jq -r 'reduce .[] as $o ({}; .[$o.monitor] += reduce $o as $item ({}; .[$item.name] = {empty:$item.empty}))'
