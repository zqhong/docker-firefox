#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# prepare for action
if [ ! -d "/config/chrome" ]; then
  sudo mkdir -pv /config/chrome
  sudo chown -R app:app /config
fi

# fix: _XSERVTransmkdir: Owner of /tmp/.X11-unix should be set to root
if [ -d "/tmp/.X11-unix" ]; then
  sudo chown -R root:root /tmp/.X11-unix
fi

sudo rm -rf /tmp/.X1-lock
sudo pgrep -a Xvfb && killall Xvfb
sudo pgrep -a x11vnc && killall x11vnc
sudo pgrep -a chromium-browser && killall chromium-browser

# start up
export DISPLAY=:1

! pgrep -a Xvfb && Xvfb $DISPLAY -screen 0 "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}x24" &
sleep 3

! pgrep -a x11vnc && x11vnc -geometry "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" \
  -passwd "$VNC_PASSWORD" \
  -autoport "$VNC_LISTENING_PORT" \
  -bg -forever -nopw -quiet \
  -display WAIT$DISPLAY &

# https://peter.sh/experiments/chromium-command-line-switches/
chromium-browser --user-data-dir="/config/chrome" \
  --profile-directory="DefaultUser" \
  --disable-gpu \
  --disable-dev-shm-usage \
  --window-size="${DISPLAY_WIDTH},${DISPLAY_HEIGHT}" \
  --window-position=0,0 \
  --process-per-site \
  --renderer-process-limit=2 \
  --enable-low-end-device-mode \
  --disable-sync
