#!/usr/bin/env python
#
# Copyright (c) Nathan Genetzky, 2020
#
# Authors:
#  Nathan Genetzky <nathan@genetzky.us>

import os
import sys
import argparse
import logging


class EntrypointContext(object):
    def __init__(self, argv=None, env=None):
        if argv is None:
            argv = []
        if env is None:
            env = {}
        # Input
        self._argv_in = argv
        self._env_in = env

        self._argv_out = []
        self._env_out = {}

    @property
    def argv(self):
        return self._argv_out

    @property
    def env(self):
        return self._env_out

    def build(self):
        """Build the arguments and environment for the process

        The default implementation will 'shift' the argv and copy the environment.
        """
        _, argv = self._parse_args()
        self._argv_out = list(argv)
        self._env_out = dict(self._env_in)
        # NOTE: THis is currently just for debugging
        logging.warning("build() -> (args={},env={})".format(context.argv, context.env))

    def _parse_args(self):
        parser = self._parser()
        return parser.parse_known_args(self._argv_in[1:])

    def _parser(self):
        # NOTE: Requires Python>3.5 but avoids "Prefix matching" issue.
        allow_abbrev = True
        if 3 <= sys.version_info.major and 5 <= sys.version_info.major:
            allow_abbrev = False
        parser = (
            argparse.ArgumentParser()
            if allow_abbrev
            else argparse.ArgumentParser(allow_abbrev=False)
        )
        # # TODO: Handle --user.
        # parser.add_argument(
        #     "-u",
        #     "--user",
        #     help="Sets the username or UID used and optionally the groupname or GID for the specified command.",
        # )
        return parser


ENTRYPOINT_LIBRARY = {
    # Requires dockcross
    # https://github.com/dockcross/dockcross
    "dockcross": ["/dockcross/entrypoint.sh"],
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

if __name__ == "__main__":  # pragma: nocover
    context = EntrypointContext(  # Not a constant # pylint: disable=invalid-name
        argv=sys.argv, env=os.environ,
    )
    context.build()
    argv = context.argv
    if len(argv) < 1:
        sys.exit(0)

    os.execvp(argv[0], argv)
