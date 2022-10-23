#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Make sure some directories are created.
mkdir -p /config/downloads
mkdir -p /config/log/firefox
mkdir -p /config/profile

# Generate machine id.
if [ ! -f /config/machine-id ]; then
    echo "generating machine-id..."
    cat /proc/sys/kernel/random/uuid | tr -d '-' > /config/machine-id
fi

# Copy default preferences.
[ -f /config/profile/prefs.js ] || cp /defaults/prefs.js /config/profile/prefs.js

# Verify the size of /dev/shm.
SHM_SIZE_MB="$(df -m /dev/shm | tail -n 1 | tr -s ' ' | cut -d ' ' -f2)"
if [ "$SHM_SIZE_MB" -eq 64 ]; then
   echo 'SHM_CHECK_FAIL' > /tmp/.firefox_shm_check
else
   echo 'SHM_CHECK_PASS' > /tmp/.firefox_shm_check
fi
chown $USER_ID:$GROUP_ID /tmp/.firefox_shm_check

if /usr/bin/membarrier_check 2>/dev/null; then
   echo 'MEMBARRIER_CHECK_PASS' > /tmp/.firefox_membarrier_check
else
   echo 'MEMBARRIER_CHECK_FAIL' > /tmp/.firefox_membarrier_check
fi
chown $USER_ID:$GROUP_ID /tmp/.firefox_membarrier_check


# Make sure monitored log files exist.
for LOG_FILE in /config/log/firefox/error.log
do
    touch "$LOG_FILE"
done

# vim: set ft=sh :
