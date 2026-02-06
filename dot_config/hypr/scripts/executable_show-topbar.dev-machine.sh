#!/usr/bin/bash

check_active=$(~/.local/bin/eww active-windows | grep 'topbar_toggle')

if [[ -n $check_active ]]; then
	exit 0
fi

~/.local/bin/eww open-many \
	topbar_toggle:tbt_primary \
	topbar_toggle:tbt_second \
	topbar_toggle:tbt_third \
	--arg tbt_primary:monitor="0" \
	--arg tbt_second:monitor="1" \
	--arg tbt_third:monitor="2"

# vim: filetype=sh:
