#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Preparing to run firefox
mkdir -p /config/downloads
mkdir -p /config/log/firefox
mkdir -p /config/profile

if [ ! -f /config/machine-id ]; then
  cat /proc/sys/kernel/random/uuid | tr -d '-' >/config/machine-id
fi

# open virtual desktop
export DISPLAY=:1

rm -f "$XAUTHORITY"
rm -f "$XAUTHORITY"-*
touch "$XAUTHORITY"
xauth add $DISPLAY . $(mcookie)

if which x11vnc >/dev/null 2>&1; then
  ! pgrep -a x11vnc && x11vnc -passwd "$VNC_PASSWORD" -autoport "$VNC_LISTENING_PORT" -bg -forever -nopw -quiet -display WAIT$DISPLAY &
fi

! pgrep -a Xvfb && Xvfb $DISPLAY -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" -auth "$XAUTHORITY" &
sleep 3
xdpyinfo -display $DISPLAY

/usr/bin/firefox --profile /config/profile --setDefaultBrowser
