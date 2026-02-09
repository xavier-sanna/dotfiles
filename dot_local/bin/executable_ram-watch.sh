#!/usr/bin/env bash
set -euo pipefail

threshold_gib="${RAM_WATCH_THRESHOLD_GIB:-14.5}"
clear_gib="${RAM_WATCH_CLEAR_GIB:-14.0}"
replace_id="${RAM_WATCH_DUNST_REPLACE_ID:-43123}"
state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/ram-watch"
state_file="${state_dir}/alerted"

if ! command -v dunstify >/dev/null 2>&1; then
  exit 0
fi

read_meminfo() {
  awk '
    /^MemTotal:/ { total=$2 }
    /^MemAvailable:/ { available=$2 }
    END {
      if (total == 0 || available == 0) {
        exit 1
      }
      print total, available
    }
  ' /proc/meminfo
}

to_kib() {
  awk -v gib="$1" 'BEGIN { printf "%.0f", gib * 1024 * 1024 }'
}

to_gib() {
  awk -v kib="$1" 'BEGIN { printf "%.2f", kib / 1024 / 1024 }'
}

read -r mem_total_kib mem_available_kib < <(read_meminfo)
mem_used_kib=$((mem_total_kib - mem_available_kib))

threshold_kib="$(to_kib "$threshold_gib")"
clear_kib="$(to_kib "$clear_gib")"

# Keep a small hysteresis gap even when misconfigured.
if [ "$clear_kib" -ge "$threshold_kib" ]; then
  clear_kib=$((threshold_kib - 262144))
fi

used_gib="$(to_gib "$mem_used_kib")"
available_gib="$(to_gib "$mem_available_kib")"
total_gib="$(to_gib "$mem_total_kib")"

top_processes="$(
  ps -eo comm,rss --sort=-rss --no-headers \
    | head -n 3 \
    | awk '
      BEGIN { first = 1 }
      {
        if (!first) {
          printf ", "
        }
        printf "%s(%.1fG)", $1, $2 / 1024 / 1024
        first = 0
      }
      END {
        if (NR == 0) {
          printf "n/a"
        }
      }
    '
)"

mkdir -p "$state_dir"

if [ "$mem_used_kib" -ge "$threshold_kib" ]; then
  if [ ! -f "$state_file" ]; then
    dunstify \
      -a "ram-watch" \
      -u critical \
      -t 0 \
      -r "$replace_id" \
      "High RAM usage: ${used_gib} GiB / ${total_gib} GiB" \
      "Threshold ${threshold_gib} GiB reached (available ${available_gib} GiB). Top: ${top_processes}"
    date +%s > "$state_file"
  fi
  exit 0
fi

if [ -f "$state_file" ] && [ "$mem_used_kib" -le "$clear_kib" ]; then
  dunstify \
    -a "ram-watch" \
    -u normal \
    -t 8000 \
    -r "$replace_id" \
    "RAM usage back to safe range" \
    "Now ${used_gib} GiB used (${available_gib} GiB available)."
  rm -f "$state_file"
fi

