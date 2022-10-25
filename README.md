# Docker-Web-Broswer

## 使用

```bash
sudo docker run -d \
    --name=web-browser \
    --privileged \
    --cpus="0.5" \
    --memory="512m" \
    -p 5900:5900 \
    -e "VNC_PASSWORD=your_password"  \
    hd2300/web-browser
```

说明：

* 资源限制：50% CPU 占用，512 MB 内存
* privileged：特权模式
* 端口映射：host 5900 -> container 5900
* VNC
    * 密码：your_password
