#!/usr/bin/env bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

cd /opt/

git clone "https://github.com/NGenetzky/bitbake.bblayer" /opt/bitbake/

cd /opt/bitbake/
git checkout -B build 'ca33d32f887b54eeb8ff70f7e660510fedb56197' ;
git submodule update --init bitbake

mkdir -p '/opt/bitbake/build/conf'

cat << EOF >> /opt/bitbake/build/conf/kas.yml
header:
  version: 8
env:
  SHELL: bash # NOTE: This isn't **really** needed, but I like bash.
target: world
repos:
  bblayer:
    url: /opt/bitbake/
    refspec: ca33d32f887b54eeb8ff70f7e660510fedb56197
    layers:
      bb_core:
      bb_fetch:
      examples/bitbake-core-fetch/layers/example:
EOF

kas shell /opt/bitbake/build/conf/kas.yml -c 'bitbake-layers show-layers'

