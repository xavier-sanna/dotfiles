#!/usr/bin/bash

check_active=$(~/.local/bin/eww active-windows | grep 'powermenu_toggle')

if [[ -n $check_active ]]; then
	exit 0
fi

~/.local/bin/eww open-many \
	powermenu_toggle:pm_primary \
	powermenu_toggle:pm_second \
	powermenu_toggle:pm_third \
	--arg pm_primary:monitor="0" \
	--arg pm_second:monitor="1" \
	--arg pm_third:monitor="2"
