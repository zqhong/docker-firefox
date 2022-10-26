#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

export DISPLAY=:1

export LOCK_FILE="/config/.lock"
export VNC_PASSWORD_FILE="/config/.vncpass"

export CERT_DIR="/config/certs"
export CERT_KEY_FILE="$CERT_DIR/vnc-private-key.pem"
export CERT_CERT_FILE="$CERT_DIR/vnc-fullchain-cert.pem"

# Prepare for action
if [ ! -f "$LOCK_FILE" ]; then
  # Without initialization
  sudo rm -rf /config

  sudo mkdir -pv /config/chrome
  sudo mkdir -pv "$CERT_DIR"
  sudo chown -R app:app /config

  echo "$VNC_PASSWORD" | /usr/bin/vncpasswd -f >"$VNC_PASSWORD_FILE"

  env HOME=/tmp openssl req \
    -x509 \
    -nodes \
    -days 3650 \
    -newkey rsa:2048 \
    -subj "/C=CA/O=github.com\\/zqhong\\/$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/OU=Docker container VNC access/CN=vnc.$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').example.com" \
    -keyout "$CERT_KEY_FILE" \
    -out "$CERT_CERT_FILE"
  chmod 400 "$CERT_KEY_FILE"

  touch "$LOCK_FILE"
fi

# Start up
! pgrep -a Xvnc && /usr/bin/Xvnc -nolisten local \
  -nolisten unix \
  -listen tcp \
  -geometry "${DISPLAY_WIDTH}x${DISPLAY_HEIGHT}" \
  -depth "$DISPLAY_DEPTH" \
  -rfbport="$VNC_LISTENING_PORT" \
  -UseIPv6=no \
  -rfbauth="$VNC_PASSWORD_FILE" \
  -SecurityTypes="X509Vnc" \
  -X509Key="$CERT_KEY_FILE" \
  -X509Cert="$CERT_CERT_FILE" \
  -desktop="$APP_NAME" \
  -Log="*:stdout:100" \
  "$DISPLAY" &

# Wait for the Xvnc process to start
while ! pgrep -a Xvnc; do
  sleep 0.5
done

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
