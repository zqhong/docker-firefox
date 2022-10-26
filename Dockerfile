FROM alpine:3.16

# Define working directory.
WORKDIR /tmp

# Install the base environment
RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \
    apk add tigervnc && \
    apk add openssl && \
    apk add ttf-dejavu && \
    apk add xdotool && \
    apk add wqy-zenhei --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add unzip && \
    apk add sudo && \
    apk add tzdata

# Install chromium
RUN \
    apk add chromium

# Set environment variables.
ENV \
    APP_NAME="WebBrowser" \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DISPLAY_DEPTH=24 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    TZ="Asia/Chongqing"

RUN \
    cp /usr/share/zoneinfo/"$TZ" /etc/localtime && \
    ntpd -d -q -n -p ntp.aliyun.com

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Expose ports.
#   - 5900: VNC
EXPOSE 5900

# Creating a non-root user
ARG USERNAME=app

RUN adduser -D $USERNAME \
        && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
        && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

ENTRYPOINT ["/entrypoint.sh"]
