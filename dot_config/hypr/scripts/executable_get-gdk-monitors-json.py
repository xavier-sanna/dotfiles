#!/usr/bin/env python3

import json

import gi

gi.require_version("Gdk", "3.0")
from gi.repository import Gdk


def main() -> None:
    display = Gdk.Display.get_default()
    if display is None:
        print("[]")
        return

    monitors = []
    for i in range(display.get_n_monitors()):
        monitor = display.get_monitor(i)
        geometry = monitor.get_geometry()
        monitors.append(
            {
                "index": i,
                "x": geometry.x,
                "y": geometry.y,
            }
        )

    print(json.dumps(monitors))


if __name__ == "__main__":
    main()
