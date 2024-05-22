from libqtile.command.client import InteractiveCommandClient
c = InteractiveCommandClient()

from autostart import AUTOSTART
import subprocess

for p in AUTOSTART:
    subprocess.Popen(p.split())



