#!/usr/bin/env python

import dbus
import dbus.service
import subprocess
import os
from gi.repository import GLib
from dbus.mainloop.glib import DBusGMainLoop

OPATH    = "/org/freedesktop/FileManager1"
IFACE    = "org.freedesktop.FileManager1"
BUS_NAME = "org.freedesktop.FileManager1"

loop = None

def open_filemanager(uri, select=False):
    args = ["kitty", "-e", "vifm"]
    if select: args.append("--select")

    path = str(uri)
    if path.startswith("file://"): path = path[7:]
    args.append(path)

    if os.fork() == 0:
        subprocess.Popen(args)
        os._exit(0)
    else:
        os.wait()

class FileManager1(dbus.service.Object):
    def __init__(self):
        self.loop = GLib.MainLoop()

        bus = dbus.SessionBus()
        bus.request_name(BUS_NAME)
        busname = dbus.service.BusName(BUS_NAME, bus)
        dbus.service.Object.__init__(self, busname, OPATH)

    @dbus.service.method(IFACE, in_signature="ass", out_signature="")
    def ShowFolders(self, uris, _):
        open_filemanager(uris[0])

    @dbus.service.method(IFACE, in_signature="ass", out_signature="")
    def ShowItems(self, uris, _):
        open_filemanager(uris[0], select=True)

    @dbus.service.method(IFACE, in_signature="ass", out_signature="")
    def ShowItemProperties(self, uris, _):
        open_filemanager(uris[0], select=True)

    @dbus.service.method("org.freedesktop.FileManager1",
                         in_signature="", out_signature="")
    def Exit(self):
        self.loop.quit()

if __name__ == "__main__":
    DBusGMainLoop(set_as_default=True)
    fm = FileManager1()
    fm.loop.run()
