#!/usr/bin/env python
#
# Copyright (c) Nathan Genetzky, 2020
#
# Authors:
#  Nathan Genetzky <nathan@genetzky.us>

import os

CMD_LIBRARY = {
    # Requires dockcross
    # https://github.com/dockcross/dockcross
    "dockcross": ["/dockcross/entrypoint.sh",],
    # Requires phusion-docker
    # https://github.com/phusion/baseimage-docker
    "phusion-dockcross": [
        "/sbin/my_init",
        "--quiet",
        "--skip-startup-files",
        "--",
        "/dockcross/entrypoint.sh",
    ],
}

cmd = CMD_LIBRARY["dockcross"]

os.execvp(cmd[0], cmd)
