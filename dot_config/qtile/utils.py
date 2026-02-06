#
# Get Monitors
#
def get_enabled_monitors():
    import gi

    gi.require_version("Gdk", "3.0")
    from gi.repository import Gdk

    allmonitors = list()

    gdkdsp = Gdk.Display.get_default()

    for i in range(gdkdsp.get_n_monitors()):
        monitor = gdkdsp.get_monitor(i)
        #        scale = monitor.get_scale_factor()
        #        geo = monitor.get_geometry()

        data = {"name": monitor.get_model()}

        allmonitors.append(data)

    return allmonitors


def debug_log(var_name=None, value=""):
    import os

    if var_name is None:
        var_name = "UNDEF"

    with open(
        f"{os.getenv('HOME')}/.local/share/qtile/qtile.debug.log", "a"
    ) as file_object:
        file_object.write("\n")
        file_object.write(f"[{var_name}] {value}")
