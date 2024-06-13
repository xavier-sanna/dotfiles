from libqtile.config import Group
from libqtile import layout
from libqtile.layout.xmonad import MonadThreeCol, MonadWide

MTC_SINGLE_LR_MARGIN=1280

monadThreeCols = MonadThreeCol(margin=100, single_margin=[100, MTC_SINGLE_LR_MARGIN, 100, MTC_SINGLE_LR_MARGIN])
monadThreeCols2 = MonadThreeCol(margin=50, single_margin=[50, MTC_SINGLE_LR_MARGIN, 50, MTC_SINGLE_LR_MARGIN], ratio=0.6)
monadWide = MonadWide(margin=50, single_margin=[50, MTC_SINGLE_LR_MARGIN, 50, MTC_SINGLE_LR_MARGIN], ratio=0.7)

GROUPS = {
    "dev-machine": {
        "DP-2": [
            {
                "opts": {
                    "label": "",
                    "layout": "monadwide",
                    "layouts": [monadThreeCols2],
                },
                "key": "1",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "2",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "3",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "4",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "5",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "6",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "7",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "8",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "9",
            },
            {
                "opts": {
                    "label": "",
                    "layout": "monadthreecol",
                    "layouts": [monadThreeCols],
                },
                "key": "0",
            },
        ],
        # "HDMI-0": [
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F1",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F2",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F3",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F4",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F5",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F6",
        #     },
        # ],
        # "HDMI-1": [
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F7",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F8",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F9",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F10",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F11",
        #     },
        #     {
        #         "opts": {
        #             "label": "",
        #             "layout": "monadthreecol",
        #             "layouts": [MonadThreeCol(margin=30, single_margin=30)],
        #         },
        #         "key": "F12",
        #     }
        # ],
    }
}


def get_groups():
    from socket import gethostname

    from utils import get_enabled_monitors

    groups = []

    for mon_idx, mon in enumerate(get_enabled_monitors()):
        for grp_idx, grp in enumerate(GROUPS[gethostname()][mon['name']]):
                groups.append(
                    Group(
                        **grp['opts'],
                        name=f"{mon_idx}-{grp_idx}",
                        screen_affinity=mon_idx,
                    )
                )

    return groups
