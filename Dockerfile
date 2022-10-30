FROM frolvlad/alpine-glibc:alpine-3.16_glibc-2.35

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# alpine already has a gid 999, so we'll use the next id
RUN addgroup -S -g 1000 chromium && adduser -S -G chromium -u 999 chromium

WORKDIR /tmp

COPY entrypoint.sh /

ENV \
    APP_NAME="WebBrowser" \
    DISPLAY_WIDTH=1920 \
    DISPLAY_HEIGHT=1080 \
    DISPLAY_DEPTH=24 \
    VNC_LISTENING_PORT=5900 \
    VNC_PASSWORD=default_password_2cQ1q0YV \
    TZ="Asia/Chongqing"

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
