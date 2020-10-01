#!/usr/bin/env bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

BITBAKE_ROOT='/opt/bitbake'
mkdir -p \
    "${BITBAKE_ROOT}/build/conf" \
    "${BITBAKE_ROOT}/build/layers"
cd "${BITBAKE_ROOT}"

BASE_LAYER_PATH="build/layers/meta-bb-project-base"
cat << EOF >> build/conf/kas.yml
header:
  version: 8
env:
  SHELL: /bin/bash
target: world
repos:
  meta-bb-project-base:
    url: "https://gitlab.com/ngenetzky/meta-bb-project-base.git"
    refspec: "82ebf83e1cb4779dca16ea98bba19c1e17b0475b" # 2020-07-04
    path: "${BASE_LAYER_PATH}"
    layers:
      layers/meta-r0:
      layers/meta-r1-bb:
EOF

# This will fetch and set the 'conf' without performing a real build.
# Ideally no one is using this build directory, except to use bitbake or poky.
kas shell build/conf/kas.yml -c 'bitbake-layers show-layers'

# Clean up any unneccessary files
git -C "${BASE_LAYER_PATH}" \
  clean -fdx
rm -rf \
  build/bitbake-cookerdaemon.log \
  build/bitbake.lock \
  build/cache/ \
  build/tmp/
