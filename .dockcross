#!/bin/bash
set -x

cat << EOF >> /tmp/tmuxp.yml
session_name: shorthands
windows:
  - window_name: long form
    panes:
    - shell_command:
      - echo 'did you know'
      - echo 'you can inline'
    - shell_command: echo 'single commands'
    - echo 'for panes'
EOF

# d         Load the session without attaching it
tmuxp load -d /tmp/tmuxp.yml
