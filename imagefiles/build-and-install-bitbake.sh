#!/usr/bin/env bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

BITBAKE_ROOT='/opt/bitbake'
mkdir -p \
    "${BITBAKE_ROOT}/build/conf" \
    "${BITBAKE_ROOT}/layers"
cd "${BITBAKE_ROOT}"

BASE_LAYER_PATH="layers/meta-bb-ngenetzky"
cat << EOF >> build/conf/kas.yml
header:
  version: 8
env:
  SHELL: /bin/bash # NOTE: This isn't **really** needed, but I like bash.
target: world
repos:
  meta-bb-ngenetzky:
    url: "https://github.com/NGenetzky/meta-bb-ngenetzky.git"
    refspec: "2cbaa232df4b4f0cf1a0642ea7b1e5b0d48326b9"
    path: "${BASE_LAYER_PATH}"
    layers:
      layers/meta-r0:
      layers/meta-r1-bb:
      layers/meta-r2-bitbake-yocto:
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

# Use symlink to provide consistent location for bitbake
ln -fsT "${BASE_LAYER_PATH}/bitbake" bitbake
