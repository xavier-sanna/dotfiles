#!/usr/bin/bash

set -u

log_file="${XDG_RUNTIME_DIR:-/tmp}/ags-superbar.log"

printf '[%s] starting superbar\n' "$(date -Is)" >>"$log_file"

# Hyprland starts before interactive shell rc files, so ensure PATH here.
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Non-interactive Hyprland startup does not source zshrc, so enable mise tools
# (e.g. npm:sass) explicitly for AGS.
if command -v mise >/dev/null 2>&1; then
	eval "$(mise activate bash)"
else
	printf '[%s] mise not found (PATH=%s)\n' "$(date -Is)" "$PATH" >>"$log_file"
fi

# Give the session a short moment to settle before AGS starts.
sleep 2

if ! command -v ags >/dev/null 2>&1; then
	printf '[%s] ags not found (PATH=%s)\n' "$(date -Is)" "$PATH" >>"$log_file"
	exit 1
fi

if ! command -v sass >/dev/null 2>&1; then
	printf '[%s] sass not found (PATH=%s)\n' "$(date -Is)" "$PATH" >>"$log_file"
fi

ags run "$HOME/projects/xs/ags/superbar/superbar.tsx" >>"$log_file" 2>&1

# vim: filetype=sh:
