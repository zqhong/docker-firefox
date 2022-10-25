#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# open virtual desktop
sudo rm -rf /tmp/.X1-lock
sudo pgrep -a Xvfb && killall Xvfb
sudo pgrep -a x11vnc && killall x11vnc
sudo pgrep -a chromium-browser && killall chromium-browser

export DISPLAY=:1

! pgrep -a Xvfb && Xvfb $DISPLAY -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" &
sleep 3
# _XSERVTransmkdir: Owner of /tmp/.X11-unix should be set to r

! pgrep -a x11vnc && x11vnc -geometry "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" \
  -passwd "$VNC_PASSWORD" \
  -autoport "$VNC_LISTENING_PORT" \
  -bg -forever -nopw -quiet \
  -display WAIT$DISPLAY &

# https://peter.sh/experiments/chromium-command-line-switches/
chromium-browser --disable-gpu \
  --disable-dev-shm-usage \
  --window-size="${DISPLAY_WIDTH},${DISPLAY_HEIGHT}" \
  --window-position=0,0 \
  --disable-site-isolation-trials \
  --process-per-site \
  --renderer-process-limit=2 \
  --enable-low-end-device-mode \
  --single-process
