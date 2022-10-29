FROM frolvlad/alpine-glibc:alpine-3.16_glibc-2.35

# Define working directory.
WORKDIR /tmp

# Set environment variables.
ENV \
    APP_NAME="WebBrowser" \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DISPLAY_DEPTH=24 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    TZ="Asia/Chongqing" \
    USERNAME="app"

# Install the base environment
RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \
    apk add wqy-zenhei --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add tigervnc && \
    apk add openssl && \
    apk add ttf-dejavu && \
    apk add xdotool && \
    apk add unzip && \
    apk add sudo && \
    apk add tzdata

# Miscellaneous
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 5900

RUN \
    cp /usr/share/zoneinfo/"$TZ" /etc/localtime

# Creating a non-root user
RUN adduser -D $USERNAME \
        && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
        && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

# Finally, install chromium.
# Note: This can be replaced with other GUI software.
RUN \
    sudo apk add chromium

ENTRYPOINT ["/entrypoint.sh"]
