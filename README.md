# Docker-Web-Browser

[![Docker Image Size](https://img.shields.io/docker/image-size/hd2300/web-browser/latest)](https://hub.docker.com/r/hd2300/web-browser/tags)

## 使用

### 服务端

```bash
# debian/ubuntu 宿主机，创建一个仅用于 Docker 容器的用户
$ sudo useradd --no-create-home --shell /usr/sbin/nologin docker-user

$ sudo mkdir -pv /docker/appdata/web-browser
$ sudo chown -R docker-user:docker-user /docker/appdata/web-browser

$ id docker-user
uid=1001(docker-user) gid=1001(docker-user) groups=1001(docker-user) 

$ sudo docker run -d \
    --name=web-browser \
    --privileged \
    --cpus="0.5" \
    --memory="512m" \
    -p 14000:14000 \
    -e "VNC_PASSWORD=your_password_7nP40EQf"  \
    -e "UID=1001" \
    -e "GID=1001"
    -v /docker/appdata/web-browser:/config:rw \
    hd2300/web-browser:v0.8.0
```

说明：

* 资源限制：50% CPU 占用，512 MB 内存
* privileged：特权模式
* 端口映射：宿主机 14000 端口 -> Docker 容器 14000 端口
* VNC 密码：`your_password_7nP40EQf`

### 客户端

#### 下载

* Windows：[vncviewer64-1.12.0.exe](https://shorturl.at/fpqDZ)
* macOS：[TigerVNC-1.12.0.dmg](https://shorturl.at/acyKR)
* 其他平台：[VncViewer-1.12.0.jar](https://shorturl.at/swLW9)
    * 使用：`java -jar VncViewer.jar`

#### 设置正确的屏幕缩放

1. 打开 VNC Viewer 软件
2. 依次点击 `Options / Screen / Scale rmote session to local windows`
3. 选择 `Auto`

> 注意：目前只在开发版的 `VncViewer.jar` 看到有 `Scale` 选项。
> 地址：https://github.com/TigerVNC/tigervnc/actions/runs/3314362533

#### 免密码登录

```bash
java -jar VncViewer.jar -PasswordFile="/path/to/vnc_password_file" 
```

### 其他

#### Alpine Linux 设置国内源

```bash
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```

参考：https://mirrors.tuna.tsinghua.edu.cn/help/alpine/

## 附录

### 各版本资源占用对比

```bash
$ sudo docker stats --no-stream
CONTAINER ID   NAME                CPU %     MEM USAGE / LIMIT   MEM %     NET I/O           BLOCK I/O         PIDS
70c7aa0bec68   web-browser-0.8.0   0.59%     151.4MiB / 512MiB   29.56%    16.6MB / 2.11MB   13.4MB / 1.86MB   71
749d29019f08   web-browser-0.7.0   0.59%     152.1MiB / 512MiB   29.72%    19.8MB / 3.84MB   13.2MB / 2.14MB   72
51fecb260fc9   web-browser-0.6.0   0.60%     298.1MiB / 512MiB   58.21%    19.8MB / 3.76MB   306MB / 2.18MB    73    
```

字段说明：

| Column name | Description |
| --- | --- |
| `CONTAINER ID` and `Name` | the ID and name of the container |
| `CPU %` and `MEM %` | the percentage of the host’s CPU and memory the container is using |
| `MEM USAGE / LIMIT` | the total memory the container is using, and the total amount of memory it is allowed to use |
| `NET I/O` | The amount of data the container has sent and received over its network interface |
| `BLOCK I/O` | The amount of data the container has read to and written from block devices on the host |
| `PIDs` | the number of processes or threads the container has created |

参考：
https://docs.docker.com/engine/reference/commandline/stats/

### set -eux

```bash
#  -e  Exit immediately if a command exits with a non-zero status.
#  -u  Treat unset variables as an error when substituting.
#  -x  Print commands and their arguments as they are executed.
set -eux
```

### sudo、gosu、su-exec

> Avoid installing or using sudo as it has unpredictable TTY and signal-forwarding behavior that can cause problems.
> If you absolutely need functionality similar to sudo, such as initializing the daemon as root but running it as
> non-root, consider using “gosu”.

应避免使用 `sudo`，可以使用 `gosu` 替代。

> After ncopa/su-exec@f85e5bd (`su-exec` 0.2+), `su-exec` now has parity with `gosu` (as verified by `gosu`'s new test
> suite) such that it's acceptable to use as a `gosu` replacement in our Alpine-based variant for the size
> consideration.

`su-exec` 0.2+ 版本开始，与 `gosu` 兼容。考虑占用空间大小，使用 `su-exec` 替代 `gosu`。

参考：

* https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
* https://github.com/docker-library/redis/commit/cfa9febb7afdc2af1bb1195c66c50f9bae9ac703
