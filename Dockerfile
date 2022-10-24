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
    apk add sudo && \
    apk add xdotool

# Creating a non-root user
ARG USERNAME=app
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

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

# Expose ports.
#   - 5900: VNC
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
