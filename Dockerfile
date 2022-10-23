# Build the membarrier check tool.
FROM alpine:3.14 AS membarrier
WORKDIR /tmp
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.0.4

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG FIREFOX_VERSION=101.0.1-r0

# Define working directory.
WORKDIR /tmp

# Install Firefox.
RUN \
     add-pkg firefox=${FIREFOX_VERSION}

# Install extra packages.
RUN \
    add-pkg \
        # Icons used by folder/file selection window (when saving as).
        gnome-icon-theme \
        # A font is needed.
        ttf-dejavu \
        # The following package is used to send key presses to the X process.
        xdotool

# Set default settings.
RUN \
    CFG_FILE="$(ls /usr/lib/firefox/browser/defaults/preferences/firefox-branding.js)" && \
    echo '' >> "$CFG_FILE" && \
    echo '// Default download directory.' >> "$CFG_FILE" && \
    echo 'pref("browser.download.dir", "/config/downloads");' >> "$CFG_FILE" && \
    echo 'pref("browser.download.folderList", 2);' >> "$CFG_FILE"

# Enable log monitoring.
RUN \
    sed-patch 's|LOG_FILES=|LOG_FILES=/config/log/firefox/error.log|' /etc/logmonitor/logmonitor.conf && \
    sed-patch 's|STATUS_FILES=|STATUS_FILES=/tmp/.firefox_shm_check,/tmp/.firefox_membarrier_check|' /etc/logmonitor/logmonitor.conf

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://github.com/jlesage/docker-templates/raw/master/jlesage/images/firefox-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=membarrier /tmp/membarrier_check /usr/bin/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Firefox" && \
    set-cont-env APP_VERSION "$FIREFOX_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    FF_OPEN_URL= \
    FF_KIOSK=0

# Metadata.
LABEL \
      org.label-schema.name="firefox" \
      org.label-schema.description="Docker container for Firefox" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/zqhong/docker-firefox" \
      org.label-schema.schema-version="1.0"
