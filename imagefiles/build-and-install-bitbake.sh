#!/usr/bin/env bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

YOCTO_ROOT='/opt/yocto'
mkdir -p \
    "${YOCTO_ROOT}/build/conf" \
    "${YOCTO_ROOT}/build/layers"
cd "${YOCTO_ROOT}"

# Latest LTS release
_DEFAULT_KAS_POKY_VERSION="3.1.2"

KAS_POKY_VERSION="${_DEFAULT_KAS_POKY_VERSION-${_DEFAULT_KAS_POKY_VERSION}}"
KAS_POKY_PATH="build/layers/poky"
cat << EOF >> build/conf/kas.yml
header:
  version: 8
env:
  SHELL: /bin/bash
target: world
repos:
  poky:
    url: "https://git.yoctoproject.org/git/poky"
    refspec: "yocto-${KAS_POKY_VERSION}"
    path: "${KAS_POKY_PATH}"
    layers:
      meta:
      meta-poky:
      meta-yocto-bsp:
EOF

# This will fetch and set the 'conf' without performing a real build.
# Ideally no one is using this build directory, except to use bitbake or poky.
kas shell build/conf/kas.yml -c 'bitbake-layers show-layers'

# Clean up any unneccessary files
git -C "${KAS_POKY_PATH}" \
  clean -fdx
rm -rf \
  build/bitbake-cookerdaemon.log \
  build/bitbake.lock \
  build/cache/ \
  build/tmp/
