#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export DISPLAY=:1
export VNC_PASSWORD_FILE="/config/.vncpass"

# prepare for action
if [ ! -d "/config/chrome" ]; then
  sudo mkdir -pv /config/chrome
  sudo chown -R app:app /config
fi

if [ ! -f "$VNC_PASSWORD_FILE" ]; then
  echo "$VNC_PASSWORD" | /usr/bin/vncpasswd -f >"$VNC_PASSWORD_FILE"
fi

# xdpyinfo -display "$DISPLAY"

# start up
! pgrep -a Xvnc && /usr/bin/Xvnc -nolisten local -nolisten unix -listen tcp \
  -geometry "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" -depth "$DISPLAY_DEPTH" \
  -rfbport="$VNC_LISTENING_PORT" -UseIPv6=no -rfbauth="$VNC_PASSWORD_FILE" -SecurityTypes="TLSVnc" \
  -desktop="$APP_NAME" "$DISPLAY" &
sleep 3

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
