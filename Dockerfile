FROM frolvlad/alpine-glibc:alpine-3.16_glibc-2.35

ENV \
    UID=1001 \
    GID=1001 \
    APP_NAME="WebBrowser" \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DISPLAY_DEPTH=24 \
    VNC_LISTENING_PORT=14000 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    TZ="Asia/Chongqing"

WORKDIR /tmp

COPY entrypoint.sh /

# 安装包按 A-Z 顺序排序
# Aa、Bb、Cc、Dd、Ee、Ff、Gg、Hh、Ii、Jj、Kk、
# Ll、Mm、Nn、Oo、Pp、Qq、Rr、Ss、Tt、Uu、Vv、Ww、Xx、Yy、Zz
RUN set -eux; \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories; \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories; \
    apk add --no-cache \
        chromium \
        openssl \
        'su-exec>=0.2' \
        tigervnc \
        ttf-dejavu \
        tzdata \
        unzip \
        ; \
    apk add --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing wqy-zenhei; \
    chmod +x /entrypoint.sh

EXPOSE 14000

ENTRYPOINT ["/entrypoint.sh"]
