#!/usr/bin/env bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

mkdir -p \
    /opt/bitbake/build/conf/ \
    /opt/bitbake/build/layers/

cd /opt/bitbake/

cat << EOF >> build/conf/kas.yml
header:
  version: 8
env:
  SHELL: /bin/bash # NOTE: This isn't **really** needed, but I like bash.
target: world
repos:
  poky:
    url: "https://git.yoctoproject.org/git/poky"
    refspec: yocto-2.6.4
    path: "build/layers/yocto-2.6.4/poky/"
    layers:
      meta:
      meta-poky:
      meta-yocto-bsp:
EOF

kas shell build/conf/kas.yml -c 'bitbake-layers show-layers'

