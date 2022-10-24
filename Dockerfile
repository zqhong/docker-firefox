FROM alpine:3.16

# Define working directory.
WORKDIR /tmp

# Install the base environment
RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories &&  \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories &&  \
    apk add xvfb && \
    apk add x11vnc && \
    apk add ttf-dejavu && \
    apk add xdotool

# Install chromium.
RUN \
    apk add chromium

# Set environment variables.
ENV \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Add files.
COPY rootfs/ /

# Expose ports.
#   - 5900: VNC
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
