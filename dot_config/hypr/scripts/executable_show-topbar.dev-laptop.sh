#!/usr/bin/bash

check_active=$(~/.local/bin/eww active-windows | grep 'topbar_toggle')

if [[ -n $check_active ]]; then
	exit 0
fi

~/.local/bin/eww open topbar_toggle --arg monitor="0"

# vim: filetype=sh:
