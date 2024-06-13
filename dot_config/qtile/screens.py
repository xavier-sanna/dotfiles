from socket import gethostname

from libqtile.config import Screen

from libqtile import bar, widget
from os import getenv

from groups import GROUPS
from utils import get_enabled_monitors, debug_log


def get_screen_groups(idx):
    if len(get_enabled_monitors()) > 1:
        groups = list(GROUPS[gethostname()][get_enabled_monitors()[idx]["name"]])

        return [f"{idx}-{i}" for i in range(len(groups))]
    else:
        return None


SCREENS = {
    "dev-machine": {
        "DP-2": {
            "wallpaper": f"{getenv('HOME')}/.config/qtile/assets/wallpapers/51202861651_7d1784fbec_o.png",
            "wallpaper_mode": "stretch",
            "top": bar.Bar(
                [
                    widget.CurrentLayout(),
                    widget.GroupBox(visible_groups=get_screen_groups(0)),
                    widget.Prompt(),
                    widget.Chord(
                        chords_colors={
                            "launch": ("#ff0000", "#ffffff"),
                        },
                        name_transform=lambda name: name.upper(),
                    ),
                    widget.TextBox("default config", name="default"),
                    widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                    # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                    # widget.StatusNotifier(),
                    widget.Systray(),
                    widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                    widget.QuickExit(),
                ],
                24,
                opacity=0.7,
            ),
        },
        # "HDMI-0": {
        #     "wallpaper": f"{getenv('HOME')}/.config/qtile/assets/wallpapers/fuji.jpg",
        #     "wallpaper_mode": "stretch",
        #     "top": bar.Bar(
        #         [
        #             widget.CurrentLayout(),
        #             widget.GroupBox(visible_groups=get_screen_groups(1)),
        #             widget.Prompt(),
        #             widget.Chord(
        #                 chords_colors={
        #                     "launch": ("#ff0000", "#ffffff"),
        #                 },
        #                 name_transform=lambda name: name.upper(),
        #             ),
        #             widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        #         ],
        #         24,
        #     ),
        # },
        # "HDMI-1": {
        #     "wallpaper": f"{getenv('HOME')}/.config/qtile/assets/wallpapers/arch-synth.png",
        #     "wallpaper_mode": "stretch",
        #     "top": bar.Bar(
        #         [
        #             widget.CurrentLayout(),
        #             widget.GroupBox(visible_groups=get_screen_groups(2)),
        #             widget.Prompt(),
        #             widget.Chord(
        #                 chords_colors={
        #                     "launch": ("#ff0000", "#ffffff"),
        #                 },
        #                 name_transform=lambda name: name.upper(),
        #             ),
        #             widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
        #         ],
        #         24,
        #     ),
        # },
    }
}


def get_screens():
    from socket import gethostname

    from utils import get_enabled_monitors

    return [Screen(**SCREENS[gethostname()][m["name"]]) for m in get_enabled_monitors()]
