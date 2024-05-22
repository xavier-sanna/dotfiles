from libqtile.lazy import lazy
from libqtile.config import Key
from libqtile.utils import guess_terminal

from mods import *


MOVEMENT = [
    [[MOD], "h", [lazy.layout.left()], "Move focus to lefts"],
    [[MOD], "l", [lazy.layout.right()], "Move focus to right"],
    [[MOD], "j", [lazy.layout.down()], "Move focus down"],
    [[MOD], "k", [lazy.layout.up()], "Move focus up"],
]

SWAP = [
    [
        [MOD, SHIFT],
        "h",
        [lazy.layout.shuffle_left()],
        "Move window to the left",
    ],
    [
        [MOD, SHIFT],
        "l",
        [lazy.layout.shuffle_right()],
        "Move window to the right",
    ],
    [
        [MOD, SHIFT],
        "j",
        [lazy.layout.shuffle_down()],
        "Move window down",
    ],
    [
        [MOD, SHIFT],
        "k",
        [lazy.layout.shuffle_up()],
        "Move window up",
    ],
    [
        [MOD, SHIFT],
        "space",
        [lazy.layout.next()],
        "Move window focus to other window",
    ],
]

SIZE = [
    [
        [MOD, CTRL],
        "h",
        [lazy.layout.grow_left()],
        "Grow window to the left",
    ],
    [
        [MOD, CTRL],
        "l",
        [lazy.layout.grow_right()],
        "Grow window to the right",
    ],
    [
        [MOD, CTRL],
        "j",
        [lazy.layout.grow_down()],
        "Grow window down",
    ],
    [[MOD, CTRL], "k", [lazy.layout.grow_up()], "Grow window up"],
    [[MOD], "n", [lazy.layout.normalize()], "Reset all window sizes"],
]

WINDOW = [[[MOD], "q", [lazy.window.kill()], "Kill focused window"]]

# LAYOUTS = [
#    # [[MOD], "Tab", lazy.next_layout(), "Toggle between layouts"],
# ]

APPLICATIONS = [
    [[MOD], "Return", [lazy.spawn(guess_terminal("kitty"))], "Launch terminal"],
    [[MOD], "space", [lazy.spawn("rofi -show drun")], "launch rofi drun"],
    [[], "Print", [lazy.spawn("flameshot gui")], "launch flameshot GUI"],
]

QTILE = [
    [
        [MOD, CTRL],
        "r",
        [lazy.reload_config()],
        "Reload the config",
    ],
    [[MOD, CTRL], "q", [lazy.shutdown()], "Shutdown Qtile"],
    [[MOD, SHIFT], "r", [lazy.restart()], "Restart Qtile"],
]


def generate_group_keys():
    from socket import gethostname

    from utils import get_enabled_monitors
    from groups import GROUPS

    keys = []

    for mon_idx, mon in enumerate(get_enabled_monitors()):
        for group_idx, group_def in enumerate(GROUPS[gethostname()][mon["name"]]):
            keys.extend(
                [
                    [
                        [MOD],
                        group_def["key"],
                        [
                            lazy.to_screen(mon_idx),
                            lazy.group[f"{mon_idx}-{group_idx}"].toscreen(mon_idx),
                        ],
                        f"switch to group {mon_idx}-{group_idx} on screen {mon_idx}: {mon['name']}",
                    ],
                    [
                        [MOD, SHIFT],
                        group_def["key"],
                        [lazy.window.togroup(f"{mon_idx}-{group_idx}")],
                        f"move to group {mon_idx}-{group_idx} on screen {mon_idx}: {mon['name']}",
                    ],
                ]
                )

    return keys


GROUPS = generate_group_keys()


def load():
    definitions = [*MOVEMENT, *SWAP, *SIZE, *WINDOW, *APPLICATIONS, *QTILE, *GROUPS]

    return [
        Key(mods, key, *cmd, desc=desc)
        for mods, key, cmd, desc in definitions
    ]
