#!/usr/bin/bash

check_active=$(~/.local/bin/eww active-windows | grep 'topbar')

if [[ -n $check_active ]]; then
	exit 0
fi

~/.local/bin/eww open-many \
	topbar:tb_primary \
	topbar:tb_second \
	topbar:tb_third \
	--arg tb_primary:monitor="0" \
	--arg tb_second:monitor="1" \
	--arg tb_third:monitor="2"
