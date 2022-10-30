FROM frolvlad/alpine-glibc:alpine-3.16_glibc-2.35

WORKDIR /tmp

ENV \
    APP_NAME="WebBrowser" \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DISPLAY_DEPTH=24 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    TZ="Asia/Chongqing" \
    USERNAME="app"

RUN \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories && \
    apk add chromium && \
    apk add openssl && \
    apk add sudo && \
    apk add tigervnc && \
    apk add ttf-dejavu && \
    apk add tzdata && \
    apk add unzip && \
    apk add wqy-zenhei --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing && \
    apk add xdotool

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 5900

RUN \
    cp /usr/share/zoneinfo/"$TZ" /etc/localtime

RUN adduser -D $USERNAME \
        && echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
        && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

ENTRYPOINT ["/entrypoint.sh"]
