#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# open virtual desktop
xvfb-run --listen-tcp \
  --server-num=76 \
  --server-arg="-screen 0 ${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" \
  --auth-file="$XAUTHORITY" \
  /usr/bin/firefox --profile /config/profile --setDefaultBrowser &

# xvfb-run startup takes some time, waiting for a while
/bin/sleep 5s

# run x11vnc
/usr/bin/x11vnc -display :76 -passwd "$VNC_PASSWORD" -forever -autoport "$VNC_LISTENING_PORT"
