#!/usr/bin/bash

check_active=$(~/.local/bin/eww active-windows | grep 'powermenu_toggle_workspace')

if [[ -n $check_active ]]; then
	exit 0
fi

~/.local/bin/eww open-many \
	powermenu_toggle_workspace:pmw_primary \
	powermenu_toggle_workspace:pmw_second \
	powermenu_toggle_workspace:pmw_third \
	--arg pmw_primary:monitor="0" \
	--arg pmw_second:monitor="1" \
	--arg pmw_third:monitor="2"
