#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# open virtual desktop
export DISPLAY=:1

! pgrep -a Xvfb && Xvfb $DISPLAY -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" &
sleep 3

! pgrep -a x11vnc && x11vnc -passwd "$VNC_PASSWORD" -autoport "$VNC_LISTENING_PORT" -bg -forever -nopw -quiet -display WAIT$DISPLAY &

chromium-browser --start-fullscreen
