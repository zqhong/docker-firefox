FROM alpine:3.16

# Define software versions.
ARG FIREFOX_VERSION=106.0.1-r1

# Define working directory.
WORKDIR /tmp

# Install the base environment
RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories &&  \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories &&  \
    apk add xvfb && \
    apk add xvfb-run && \
    apk add x11vnc && \
    apk add ttf-dejavu && \
    apk add xdotool

# Install Firefox.
RUN \
    apk add firefox=${FIREFOX_VERSION}

# Set environment variables.
ENV \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    XAUTHORITY=/tmp/Xauthority

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Expose ports.
#   - 5900: VNC
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
