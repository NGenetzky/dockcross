#!/bin/bash
set -x

cat << EOF >> /tmp/kas.yml
header:
  version: 8
env:
  SHELL: /bin/bash
# target: world
target: texiep-kas-poky-minimal

repos:
  meta-bb-ngenetzky:
    url: "https://gitlab.com/ngenetzky/meta-bb-ngenetzky.git"
    refspec: 577cd51a9129969682531b73769bdfe560327c49 # 2020-10-04
    path: "build/layers/meta-bb-ngenetzky"
    layers:
      meta-r0-base:
      meta-r1-bb:
      meta-r2-bitbake:
      meta-r2-bitbake/meta-examples:
EOF

cat << EOF >> /tmp/tmuxp.yml
session_name: main
windows:
  - window_name: main
    focus: True
    layout: main-horizontal
    panes:
    - shell_command:
      - kas build '/tmp/kas.yml'
    - null
EOF

chown $BUILDER_UID:$BUILDER_GID \
  /tmp/kas.yml \
  /tmp/tmuxp.yml

# d         Load the session without attaching it
gosu $BUILDER_UID:$BUILDER_GID tmuxp load -d /tmp/tmuxp.yml
