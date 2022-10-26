# Docker-Web-Broswer

## 使用

### 服务端

```bash
sudo docker run -d \
    --name=web-browser \
    --privileged \
    --cpus="0.5" \
    --memory="512m" \
    -p 5900:5900 \
    -e "VNC_PASSWORD=your_password_7nP40EQf"  \
    hd2300/web-browser
```

说明：

* 资源限制：50% CPU 占用，512 MB 内存
* privileged：特权模式
* 端口映射：host 5900 -> container 5900
* VNC 密码：`your_password_7nP40EQf`

### 客户端

#### 下载

* Windows：[vncviewer64-1.12.0.exe](shorturl.at/fpqDZ)
* macOS：[TigerVNC-1.12.0.dmg](shorturl.at/acyKR)
* 其他平台：[VncViewer-1.12.0.jar](shorturl.at/swLW9)
    * 使用：`java -jar VncViewer.jar`

#### 设置正确的屏幕缩放

1. 打开 VNC Viewer 软件
2. 依次点击 `Options / Screen / Scale rmote session to local windows`
3. 选择 `Auto`

> 注意：目前只在开发版的 `VncViewer.jar` 看到有 `Scale` 选项。
> 地址：https://github.com/TigerVNC/tigervnc/actions/runs/3314362533

### 其他

#### Alpine Linux 设置国内源

```bash
sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
```

参考：https://mirrors.tuna.tsinghua.edu.cn/help/alpine/